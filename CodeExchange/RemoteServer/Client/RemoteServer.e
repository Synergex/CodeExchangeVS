/*******************************************************************************
*   SPECIAL VIEWING NOTE: This code has been created using
*   an indent value of 4 and a tab stop of +8.
*******************************************************************************/

/*******************************************************************************
*
*   RemoteServer
*
*   A collection of Slick-C source to connect to, communicate with and
*   work on a remote server. Loading this file will add a Tool Window
*   to your editor called "Remote Server" as well as a dialog for
*   managing your remote server settings.
*
*   Last Updated : Oct 11, 2010
*
*******************************************************************************/

#pragma option(pedantic,on)
#region Imports
#include "slick.sh"
#include "xml.sh"
#include "toolbar.sh"
#include "dockchannel.sh"
#include "RemoteServerForms.sh"
#require "sc/net/ClientSocket.e"
#import "clipbd.e"
#import "compile.e"
#import "files.e"
#import "guiopen.e"
#import "listbox.e"
#import "main.e"
#import "menu.e"
#import "options.e"
#import "projconv.e"
#import "project.e"
#import "stdprocs.e"
#import "toolbar.e"
#import "treeview.e"
#import "tbautohide.e"
#import "tbdockchannel.e"
#import "tbgrabbar.e"
#import "tbpanel.e"
#import "tbprops.e"
#import "tbtabgroup.e"
#import "tbview.e"
#import "vc.e"
#import "wkspace.e"
#endregion

using sc.net.ClientSocket;

#define TBREMOTESERVER "_tbRemoteServer"
_TOOLBAR TBRemoteServer = {TBREMOTESERVER, TBFLAG_ALLOW_DOCKING|TBFLAG_SIZEBARS,0,0,0,0,0,0,0,0,0,0,0,0,0};

// Host information structure
struct _RS_HOST
{
    _str name;      // id
    _str host;      // remote host ip or dns resolvable name
    int  port;      // remote port
    _str remote_map;// remote drive mapping
    _str local_map; // local drive mapping
};

// Reference to current selected host
_RS_HOST _rs_current_host;
// Host information array.
_RS_HOST _rs_hosts[];
// Handle to the editor control so it can be referenced outside of the dialog context
int _rs_wid;
// Last line of output section
int _rs_end_output;
// Keep track of how far through the connection we are
int _rs_connect_state;
// Background buffer for restoring window contents
_str _rs_bg_buf[];
// Helper variable for state restoring
int _rs_loaded = 0;

ClientSocket client;
int remoteOStype; //1=windows, 2=unix, 3=openvms

_str _rs_command_history[];
int _rs_hist_num = 0;

#define newconnectText  'newconnect' //connect to RemoteServer
#define connectonText   'connect' //RemoteServer response to connect
#define shutdownText    ':shutdown:'
#define okText          'DONE'


#region Command Line Routines

/**
 * Quick command to display the Remote Server toolbar.
 */
_command void ShowRemoteServer() name_info(',')
{
    tbShow(TBREMOTESERVER);
}

_command void rmtprototype() name_info(',')
{
    _str command = get_project_command("Prototype");
    if (command == null || pos("syn", command, 1, "I") == 1)
    {
        command = get_synsetting_value("proto_command_line");
    }

    if (command == null)
    {
        return;
    }

    command = _parse_project_command(command, p_buf_name, _project_name, "");
    command = TranslateRequest(command);

    _rsOutput("$" :+ command);
    _rsCommand(command);
}

_command void rmtcompile() name_info(',')
{
    _str command = get_project_command("Compile");
    if (command == null || pos("syn", command, 1, "I") == 1)
    {
        command = get_synsetting_value("compile_command_line");
    }

    if (command == null)
    {
        return;
    }

    command = _parse_project_command(command, p_buf_name, _project_name, "");
    command = TranslateRequest(command);

    _rsOutput("$" :+ command);
    _rsCommand(command);
}

_command void rmtlink() name_info(',')
{
    _str command = get_project_command("Link");
    if (command == null)
    {
        command = get_project_command("Create Library");
    }
    if (command == null)
    {
        command = get_project_command("Build");
    }
    if (command == null || pos("syn", command, 1, "I") == 1)
    {
        command = get_synsetting_value("linklibr_command_line");
    }

    if (command == null)
    {
        return;
    }

    command = _parse_project_command(command, p_buf_name, _project_name, "");
    command = TranslateRequest(command);

    _rsOutput("$" :+ command);
    _rsCommand(command);
}

/**
 * Execute command with path translation
 */
_command void rmtbld() name_info(',')
{
    _str args = arg(1);
    args = TranslateRequest(args);
    _rsOutput("$" :+ args);
    _rsCommand(args);
}

/**
 * Execute command without path translation
 */
_command void rmtcmd() name_info(',')
{
    _str args = arg(1);
    _rsOutput("$" :+ args);
    _rsCommand(args);
}

/**
 * Use rmtcfg to configure commands in the Project Properties
 * Open tab. These will only be parsed and executed when a
 * connection is established.
 */
_command void rmtcfg() name_info(',')
{
    // Do nothing
}

/**
 * Use rmtsrv as a shortcut to connect to a specific server.
 * This may be used on a command line, in project open, in a
 * project tool or on a toolbar button very easily. If a valid
 * server name is passed in and there is already a connected
 * established, the connection will be disconnected and the new
 * server will be connected.
 */
_command void rmtsrv() name_info(',')
{
    _str server = arg(1);
    if (server._length() > 0)
    {
        foreach (auto host in _rs_hosts)
        {
            if (host.name == server)
            {
                if (_rs_connect_state > 0)
                {
                    _rsDisconnect();
                    while (_rs_connect_state > 0)
                    {
                    }
                }
                if (!_rs_loaded)
                {
                    show("_tbRemoteServer");
                }
                _rs_current_host = host;
                current_server(host.name);
                _rsConnect(host.host, host.port);
                break;
            }
        }
    }
}

/**
 * Command line command to send a shutdown command to the remote
 * server.
 *
 * @warning If this command executes successfully, you will no
 *          longer be able to control the remote server until it
 *          has been started again on the remote end. Use with
 *          care.
 */
_command void rmtsrvShutdown() name_info(',')
{
    //disconnect from current client
    if ( client.isConnected() )
    {
        _rsDisconnect();
    }

    int status;

    //connect to RemoteServer
    loop
    {
        _rsDebug('rmtsrvShutdown: connecting to RemoteServer '_rs_current_host.host':'_rs_current_host.port);
        status = client.connect(_rs_current_host.host,(_str)_rs_current_host.port,1000);
        if ( status != 0 )
        {
            _rsSocketError(status,'rmtsrvShutdown: Failed to connect to RemoteServer on '_rs_current_host.host':'_rs_current_host.port);
            break;
        }
        if ( !client.isConnected() )
        {
            _rsSocketError(0,'rmtsrvShutdown: Did not connect to RemoteServer on '_rs_current_host.host':'_rs_current_host.port);
            status = 1;
            break;
        }
        _rsDebug('rmtsrvShutdown: sending 'shutdownText' message');
        status = client.send(shutdownText);
        if ( status != 0 )
        {
            _rsSocketError(status,'rmtsrvShutdown: Failure sending 'shutdownText' message to RemoteServer');
            break;
        }
        client.close();
    }
}

#endregion // Command Line Routines

/**
 * Function for establishing connection to remote server.
 * Accepts remote host in form of IP or URI and connects on the
 * port provided.
 */
int _rsConnect(_str host, int port)
{
    int status = 0;
    if (!client.valid())
    {
        ClientSocket temp;
        client = temp;
    }

    loop
    {
        _rsOutput('Connecting to remote server 'host':'port);
        _rsDebug('_rsConnect: connecting to RemoteServer 'host':'port);
        status = client.connect(host,(_str)port,1000);
        if ( status != 0 )
        {
            _rsOutput('Error connecting to remote server - '_rsSocketErrorText(status));
            if (status == SOCK_IN_USE_RC)
            {
                // If the socket is in use, lets close and retry
                client.close();
                status = client.connect(host,(_str)port,1000);
                if ( status != 0 )
                {
                    _rsSocketError(status,'_rsConnect: Failed to connect to RemoteServer on 'host':'port);
                    status = 1;
                    break;
                }
            }
            else
            {
               _rsSocketError(status,'_rsConnect: Failed to connect to RemoteServer on 'host':'port);
               status = 1;
               break;
            }
        }
        if ( !client.isConnected() )
        {
            _rsSocketError(0,'_rsConnect: Did not connect to RemoteServer on 'host':'port);
            status = 1;
            break;
        }
        _rsOutput('Connected');
        _str helloMessage = newconnectText;
        _rsDebug('_rsConnect: sending 'helloMessage' message');
        status = client.send(helloMessage);
        if ( status != 0 )
        {
            _rsSocketError(status,'_rsConnect: Failure sending 'helloMessage' message to RemoteServer');
            status = 2;
            break;
        }

        // Give the server timer enough interval so that
        // it fires. It needs at least 100 ms = delay(10),
        // but go a little higher to be safe.
        delay(100);

        _str reply = "";
        boolean not_used = false;
        process_events(not_used,'T');
        status = client.receive(reply,false,1000);

        _rsDebug('_rsConnect: closing client connection');
        client.close();

        if ( status != 0 )
        {
            _rsSocketError(status,'_rsConnect: No response from RemoteServer for 'newconnectText' message');
            status = 2;
            break;
        }
        if ( substr(reply,1,length(connectonText)," ") != connectonText )
        {
            _rsSocketError(0,'_rsConnect: Invalid RemoteServer response for 'newconnectText' message : 'reply);
            status = 2;
            break;
        }

        _str data_chunks[];
        split(reply, ":", data_chunks);

        _str strPort = data_chunks[1];
        _str strRemoteOStype = data_chunks[2];
        _str strError = data_chunks[3];

        if ((int)strPort == 0)
        {
            if (strError == null || strip(strError) == "")
            {
                strError = "RemoteServer is unable to launch rsProcess";
            }
            _rsSocketError(0,'_rsConnect: ' :+ strError);
            status = 2;
            break;
        }

        remoteOStype = (int)strRemoteOStype;

        // if no error, strError should contain version from RemoteServer
        _rsDebug('_rsConnect: RemoteServer: OStype:'strRemoteOStype' 'strError);

        _rsDebug('_rsConnect: connecting to rsProcess on 'host':'strPort);
        status = client.connect(host,strPort,1000);
        if ( status != 0 )
        {
            _rsSocketError(status,'_rsConnect: Failed to connect to rsProcess on 'host':'strPort);
            status = 3;
            break;
        }
        if ( !client.isConnected() )
        {
            _rsSocketError(0,'_rsConnect: Did not connect to rsProcess on 'host':'strPort);
            status = 3;
            break;
        }
        _rsDebug('_rsConnect: Connected to rsProcess on 'host':'strPort);

        // no errors
        _rsConnected();
        break;
    }

    if ( status != 0 )
    {
        _rsDisconnected();
    }
    return status;
}

/**
 * Execute a command remotely.
 */
int _rsCommand(_str command)
{
    int status = 0;

    loop
    {
        if ( !client.isConnected() )
        {
            _rsSocketError(0,'_rsCommand: No longer connected');
            status = 1;
            _rsDisconnected();
            break;
        }

        _rsDebug('_rsCommand: sending command : 'command);
        status = client.send(command);
        if ( status != 0 )
        {
            _rsSocketError(status,'_rsCommand: Sending command : 'command);
            break;
        }
        // Give the server timer enough interval so that
        // it fires. It needs at least 100 ms = delay(10),
        // but go a little higher to be safe.
        delay(15);

        _str reply = "";
        boolean not_used = false;
        process_events(not_used,'T');
        status = client.receive(reply,false,1000);
        if ( status != 0 )
        {
            _rsSocketError(status,'_rsCommand: Response error for send command : 'command' :');
            break;
        }

        _rsDebug('_rsCommand reply: 'reply);
        _rsOutput(TranslateResponse(reply));
        _rsDebug('_rsCommand local: 'TranslateResponse(reply));
        break;
    }

    return status;
}

/**
 * Disconnect from the remote server.
 */
int _rsDisconnect()
{
    int status = 0;

    loop
    {
        if ( !client.isConnected() )
        {
            _rsSocketError(0,'_rsDisconnect: No longer connected');
            status = 1;
            break;
        }
        _rsDebug('_rsDisconnect: sending 'shutdownText' message');
        status = client.send(shutdownText);
        if ( status != 0 )
        {
            _rsSocketError(status,'_rsDisconnect: Failure sending 'shutdownText' message');
            break;
        }

        _rsDebug('_rsDisconnect: closing client connection');
        client.close();
        break;
    }

    _rsOutput("Disconnected from remote server");

    _rsDisconnected();

    return status;
}

/**
 * Translate filenames and paths from the local format to the
 * remote format. Allows better compatability between
 * Windows/VMS and Windows/UNIX client/server pairs.
 */
_str TranslateRequest(_str request)
{

    _str convertedRequest = request;

    int localFolderSize = length(_rs_current_host.local_map);
    int remoteDirSize = length(_rs_current_host.remote_map);

    int requestSize = length(convertedRequest);
    int rpos = 1;
    int spos;
    int epos;

    loop
    {
        if ( rpos >= requestSize )
        {
            break;
        }

        // look for localmap in request
        spos = pos(_rs_current_host.local_map, convertedRequest, rpos);
        if ( spos == 0 )
        {
            break;
        }

        // is localmap filename in quotes
        if ( spos > 1 && substr(convertedRequest, spos-1, 1) == '"' )
        {
            // find matching/closing quote
            epos = pos('"', convertedRequest, spos);
            if ( epos == 0 )
            {
                break;
            }
            // is matching/closing quote on next line?
            if ( epos > pos("\r\n", convertedRequest, spos) )
            {
                rpos = pos("\r\n", convertedRequest, spos) + 2;
                continue;
            }
        }
        else
        {
            // not in quotes, so look for next space
            epos = pos(' ', convertedRequest, spos);
            if ( epos == 0 || epos > pos("\r\n", convertedRequest, spos) )
            {
                epos = pos("\r\n", convertedRequest, spos);
            }
        }

        if ( epos == 0 )
        {
            epos = requestSize+1;
            convertedRequest = substr(convertedRequest, 1, spos-1) :+ windows2remote(substr(convertedRequest, spos, epos-spos));
        }
        else
        {
            convertedRequest = substr(convertedRequest, 1, spos-1) :+ windows2remote(substr(convertedRequest, spos, epos-spos)) :+ substr(convertedRequest, epos);
        }

        rpos = epos + (remoteDirSize - localFolderSize);
        requestSize = requestSize + (remoteDirSize - localFolderSize);
    }

    return convertedRequest;
}

/**
 * Translate file names and paths from a command executed
 * remotely to a format that makes sense to this client.
 * Necessary for mapping errors to files.
 */
_str TranslateResponse(_str response)
{

    _str convertedResponse = '';

    int responseSize = length(response);
    int spos = 1;
    int epos;
    _str responseLine;
    _str filename;
    _str error_data;
    _str error_line;

    loop
    {
        if ( spos > responseSize )
        {
            break;
        }

        epos = pos("\r\n", response, spos);
        if ( epos == 0 )
        {
            epos = responseSize;
            responseLine = substr(response, spos);
        }
        else
        {
            responseLine = substr(response, spos, (epos-spos)+2);
        }

        parse responseLine with '"' filename '"(' error_line '):' error_data;

        if (filename._length() > 0 && error_line._length() > 0)
        {
            boolean isErrorLineNumber = true;
            int i;

            for (i = 1; i <= error_line._length(); i++)
            {
                if (!isdigit(_charAt(error_line, i)))
                {
                    isErrorLineNumber = false;
                }
            }
            if (isErrorLineNumber == true)
            {
                responseLine = '"' :+ remote2windows(filename) :+ '"(' :+ error_line :+ '):' :+ error_data;
            }
        }

        convertedResponse = convertedResponse :+ responseLine;
        spos = epos + 2;
    }

    return convertedResponse;
}


// _rs_current_host.local_map and _rs_current_host.remote_map must have trailing directory delimiters
_str remote2windows(_str filename)
{

    _str windowsFilename = filename;

    _str localFilename = windowsFilename;
    int filenameSize = length(filename);
    int remoteDirSize = length(_rs_current_host.remote_map);

    if ( filenameSize > remoteDirSize && remoteDirSize > 0)
    {
        // OpenVMS rooted directory
        if ( substr(_rs_current_host.remote_map, remoteDirSize-1) == '.]' )
        {
            if ( substr(filename, 1, remoteDirSize-1) == substr(_rs_current_host.remote_map, 1, remoteDirSize-1) )
            {
                localFilename = _rs_current_host.local_map :+ substr(filename, remoteDirSize);
            }
        }
        else
        {
            if ( substr(filename, 1, remoteDirSize-1) == substr(_rs_current_host.remote_map, 1, remoteDirSize-1) )
            {
                localFilename = _rs_current_host.local_map :+ substr(filename, remoteDirSize+1);
            }
        }
    }

    switch ( remoteOStype )
    {
    case 2:
        //Unix
        windowsFilename = stranslate(localFilename, '\', '/', '');
        break;
    case 3:
        //OpenVMS
        int dirSize = lastpos(']', localFilename);
        windowsFilename = substr(localFilename, 1, dirSize);
        windowsFilename = stranslate(windowsFilename, '\', '[', '');
        windowsFilename = stranslate(windowsFilename, '\', ']', '');
        windowsFilename = stranslate(windowsFilename, '\', '.', '');
        windowsFilename = windowsFilename :+ substr(localFilename, dirSize+1);
        //remove version number
        dirSize = pos(';', windowsFilename);
        if ( dirSize > 1 )
        {
            windowsFilename = substr(windowsFilename, 1, dirSize - 1);
        }
        break;
    default:
        windowsFilename = localFilename;
    }
    return windowsFilename;
}

// _rs_current_host.local_map and _rs_current_host.remote_map must have trailing directory delimiters
_str windows2remote(_str filename)
{

    _str localFilename = filename;
    int filenameSize = length(localFilename);

    // remove quotes
    if( substr(localFilename, 1, 1) == '"' && substr(localFilename, filenameSize, 1) == '"')
    {
        filenameSize = filenameSize - 2;
        localFilename = substr(localFilename, 2, filenameSize);
    }

    _str remoteFilename = localFilename;
    int remoteDirSize = length(_rs_current_host.remote_map);
    int localFolderSize = length(_rs_current_host.local_map);

    if ( filenameSize > localFolderSize )
    {
        // OpenVMS rooted directory
        if ( substr(_rs_current_host.remote_map, remoteDirSize-1) == '.]' )
        {
            if ( substr(filename, 1, localFolderSize-1) == substr(_rs_current_host.local_map, 1, localFolderSize-1) )
            {
                localFilename = _rs_current_host.remote_map :+ substr(filename, localFolderSize);
            }
        }
        else
        {
            if ( substr(filename, 1, localFolderSize-1) == substr(_rs_current_host.local_map, 1, localFolderSize-1) )
            {
                localFilename = _rs_current_host.remote_map :+ substr(filename, localFolderSize+1);
            }
        }
    }

    switch ( remoteOStype )
    {
    case 2:
        //Unix
        remoteFilename = stranslate(localFilename, '/', '\', '');
        break;
    case 3:
        //OpenVMS
        int dirSize = lastpos('\', localFilename);
        remoteFilename = substr(localFilename, 1, dirSize);
        remoteFilename = stranslate(remoteFilename, '\', '[', '');
        remoteFilename = stranslate(remoteFilename, '\', ']', '');
        remoteFilename = stranslate(remoteFilename, '\', '.', '');
        remoteFilename = remoteFilename :+ substr(localFilename, dirSize+1);
        break;
    default:
        remoteFilename = localFilename;
    }
    return remoteFilename;
}

/**
 * Remote host configuration information is stored in a def
 * variable called "def-remoteserver-hosts". This is a
 * serialized string containing the information for all of the
 * _RS_HOST structs in the array. Calls DeserializeHosts to
 * complete the process.
 */
void load_hosts()
{
    int host_index = find_index("def-remoteserver-hosts", MISC_TYPE);
    _str hosts;
    if (host_index)
    {
        hosts = name_info(host_index);

        _rs_hosts._deleteel(0, _rs_hosts._length());

        DeserializeHosts(hosts);
    }
}

/**
 * Save the serialized version of the array of _RS_HOSTS to a
 * def variable called "def-remoteserver-hosts". If it already
 * exists, clear it out first.
 */
void save_hosts()
{
    _str hosts = SerializeHosts();
    int host_index = find_index("def-remoteserver-hosts", MISC_TYPE);
    if (host_index)
    {
        delete_name(host_index);
    }

    insert_name("def-remoteserver-hosts", MISC_TYPE, hosts);
    _config_modify_flags(CFGMODIFY_DEFVAR|CFGMODIFY_DEFDATA);
}

/**
 * Store off the last used host in a serialized format.
 */
void save_last_host()
{
    _str host = HostToString(_rs_current_host);
    if (host._length() < 1)
    {
        return;
    }
    int host_index = find_index("def-remoteserver-lhost", MISC_TYPE);
    if (host_index)
    {
        delete_name(host_index);
    }

    insert_name("def-remoteserver-lhost", MISC_TYPE, host);
    _config_modify_flags(CFGMODIFY_DEFVAR|CFGMODIFY_DEFDATA);
}

/**
 * Load the last used host, deserialize it and restore it as the
 * current host. Update the remote server dropdown on the
 * toolbar.
 */
void restore_last_host()
{
    int host_index = find_index("def-remoteserver-lhost", MISC_TYPE);
    if (host_index)
    {
        _str last_host = name_info(host_index);
        _RS_HOST host = StringToHost(last_host);
        _rs_current_host = host;
        int i;
        for (i = 0; i < _rs_hosts._length(); i++)
        {
            if (_rs_hosts[i].name == host.name)
            {
                server_list.p_cb_text_box.p_text = host.name;
                break;
            }
        }
    }
}

/**
 * Deserialize a string of host information into a _RS_HOST
 * structure.
 */
_RS_HOST StringToHost(_str host_string)
{
    _str name;
    _str host;
    _str port;
    _str local_map;
    _str remote_map;
    _RS_HOST temp_host;

    parse host_string with name "\r" host "\r" port "\r" local_map "\r" remote_map;
    temp_host.name = name;
    temp_host.host = host;
    temp_host.port = (int)port;
    temp_host.local_map = local_map;
    temp_host.remote_map = remote_map;
    return temp_host;
}

/**
 * Serialize a _RS_HOST structure into a string form.
 */
_str HostToString(_RS_HOST host)
{
    return host.name "\r" host.host "\r" host.port "\r" host.local_map "\r" host.remote_map;
}

/**
 * Serialize the array of _RS_HOST structures into a single
 * string.
 */
_str SerializeHosts()
{
    _str host_array_string = "";
    foreach (auto host in _rs_hosts)
    {
        host_array_string :+= HostToString(host) :+ "\n";
    }
    return host_array_string;
}

/**
 * Deserialize a string of host information into an array of
 * _RS_HOST structures.
 */
void DeserializeHosts(_str host_array_string)
{
    _str hosts[];
    _RS_HOST temp_host;

    split(host_array_string, "\n", hosts);

    foreach (auto host_entry in hosts)
    {
        temp_host = StringToHost(host_entry);
        _rs_hosts[_rs_hosts._length()] = temp_host;
    }
}

/**
 * Called whenever a connection is established. Open the project
 * file to get a list of project Open commands. Parse through
 * these commands for anything that starts with "rmtcfg". Strip
 * the prefix and execute the commands on the remote server.
 */
void _rsRunOpenCommands()
{
    _rsDebug("_rsRunOpenCommands executed");

    int project_handle = _ProjectHandle();

    if (!project_handle)
    {
        return;
    }

    _str open_commands[];
    _ProjectGet_Macro(project_handle, open_commands);
    int i;
    for (i = 0; i < open_commands._length(); i++)
    {
        if (pos("rmtcfg", open_commands[i], 1, 'I') == 1)
        {
            _str tmp_command;
            parse open_commands[i] with "rmtcfg " tmp_command;
            if (strip(tmp_command != ""))
            {
                _str host = "";
                if (substr(tmp_command, 1, 1) == "(" && pos(")", tmp_command, 2))
                {
                    parse tmp_command with "(" host ")" tmp_command;
                    host = strip(host);
                    tmp_command = strip(tmp_command);
                }
                if (_rs_current_host.name == host || host == "*" || host == "")
                {
                    tmp_command :+ "\r\n";
                    _rsDebug("_rsRunOpenCommands:" tmp_command);
                    _rsCommand(tmp_command);
                }
            }
        }
    }

}

/**
 * Callback to put toolbar UI into a connected state. Also
 * clears the editor control, resets the output line marker,
 * clears error markers and adds the tacky looking "Command
 * Line:" label to the editor control.
 */
void _rsConnected()
{
    int wid = p_window_id;
    p_window_id = _rs_wid.p_parent;

    _rsUIConnectedState();
    _rs_wid._lbclear();

    _str temp[];
    _rs_command_history = temp;
    _rs_hist_num = 0;

    _rs_wid.insert_line("$");
    _rs_end_output = 0;

    _rs_connect_state = 1;
    _rsRunOpenCommands();
    _rs_connect_state = 2;

    p_window_id = wid;
}

void empty_buffer()
{
    _rs_wid._lbclear();
    _rs_wid.insert_line("$");
    _rs_end_output = 0;
}

/**
 * Quick and easy; put the UI into a connected state.
 */
void _rsUIConnectedState()
{
    _rsVisible();
    connect_btn.p_visible = false;
    disconnect_btn.p_visible = true;
    server_label.p_enabled = false;
    server_list.p_enabled = false;
    _rs_wid.p_enabled = true;
}

/**
 * Callback to put the toolbar UI back into a disconnected
 * state.
 */
void _rsDisconnected()
{
    _rsVisible();
    connect_btn.p_visible = true;
    disconnect_btn.p_visible = false;
    server_label.p_enabled = true;
    server_list.p_enabled = true;
    io_control.p_enabled = true;
    _rs_connect_state = 0;
}

boolean _rsVisible()
{
    // We need a handle on the editor control to do this function
    int find_rs_wid = _find_object(TBREMOTESERVER);
    if (!find_rs_wid)
    {
        ShowRemoteServer();
    }
    return true;
}

/**
 * Function to insert a CRLF delimited chunk of data into the
 * editor control. The cursor position must change relative to
 * data being inserted.
 */
void _rsOutput(_str data)
{
    _rsVisible();

    _str data_chunks[];
    int i;
    _str cline;
    boolean needs_reinsert = false;

    p_window_id = _rs_wid;
    int col = p_col;
    int line = p_line;

    p_line = p_Noflines;
    p_col = 0;

    get_line(cline);
    if (cline == "$")
    {
        _delete_line();
    }

    split(data, "\r\n", data_chunks);

    for (i = 0; i < data_chunks._length(); i++)
    {
        // don't show DONE message
        if (data_chunks[i] == okText)
        {
            data_chunks[i] = "";
        }
        // Connected, and not setting up environment
        if (_rs_connect_state != 1)
        {
            insert_line(data_chunks[i]);
        }
    }

    insert_line("$");
}

void _rsDebug(_str data)
{
    _str RmtSvrDbg = get_env("REMOTESERVERDBG");

    if ( RmtSvrDbg == "1" ) // || _rs_connect_state == 0 )
    {
       _rsOutput(data);
    }
    else if ( RmtSvrDbg == "2" )
    {
       say(data);
    }

    return;
}

void _rsSocketError(int error, _str data)
{
    switch (error)
    {
    case 0:
        _rsDebug(data);
        break;
    default:
        _rsDebug(_rsSocketErrorText(error)" \r\n"data);
    }
    return;
}

_str _rsSocketErrorText(int error)
{
    _str errorText = "";
    switch (error)
    {
    case 0:
        break;
    case SOCK_GENERAL_ERROR_RC:
        errorText = "General socket error";
        break;
    case SOCK_INIT_FAILED_RC:
        errorText = "Socks system failed to initialize";
        break;
    case SOCK_NOT_INIT_RC:
        errorText = "Socks system not initialized";
        break;
    case SOCK_BAD_HOST_RC:
        errorText = "Bad host address or host not found";
        break;
    case SOCK_NO_MORE_SOCKETS_RC:
        errorText = "No more sockets available";
        break;
    case SOCK_TIMED_OUT_RC:
        errorText = "Socket timed out";
        break;
    case SOCK_BAD_PORT_RC:
        errorText = "Bad port";
        break;
    case SOCK_BAD_SOCKET_RC:
        errorText = "Bad socket";
        break;
    case SOCK_SOCKET_NOT_CONNECTED_RC:
        errorText = "Socket not connected";
        break;
    case SOCK_WOULD_BLOCK_RC:
        errorText = "Socket would have blocked";
        break;
    case SOCK_NET_DOWN_RC:
        errorText = "Network down";
        break;
    case SOCK_NOT_ENOUGH_MEMORY_RC:
        errorText = "Not enough memory";
        break;
    case SOCK_SIZE_ERROR_RC:
        errorText = "Argument not large enough";
        break;
    case SOCK_NO_MORE_DATA_RC:
        errorText = "No more data";
        break;
    case SOCK_ADDR_NOT_AVAILABLE_RC:
        errorText = "Address not available";
        break;
    case SOCK_NOT_LISTENING_RC:
        errorText = "Socket not listening";
        break;
    case SOCK_NO_CONN_PENDING_RC:
        errorText = "No pending connections";
        break;
    case SOCK_CONN_ABORTED_RC:
        errorText = "Connection aborted";
        break;
    case SOCK_CONN_RESET_RC:
        errorText = "Connection reset";
        break;
    case SOCK_SHUTDOWN_RC:
        errorText = "Socket shut down";
        break;
    case SOCK_CONNECTION_CLOSED_RC:
        errorText = "Connection closed";
        break;
    case SOCK_NO_PROTOCOL_RC:
        errorText = "No protocol available";
        break;
    case SOCK_CONN_REFUSED_RC:
        errorText = "Connection refused";
        break;
    case SOCK_TRY_AGAIN_RC:
        errorText = "Nonauthoritative host not found";
        break;
    case SOCK_NO_RECOVERY_RC:
        errorText = "Host not found";
        break;
    case SOCK_IN_USE_RC:
        errorText = "Socket or address in use";
        break;
    default:
        errorText = "Unknown Socket Error "error;
    }
    return errorText;
}

/**
 * Call with: control_name.refresh_host_list() to set window
 * context. This routine fils a list box with the names of the
 * currently configured hosts.
 */
void refresh_host_list()
{
    load_hosts();
    p_window_id.p_cb_list_box._lbclear();
    foreach (auto host in _rs_hosts)
    {
        p_window_id.p_cb_list_box._lbadd_item(host.name);
    }
    if (p_window_id.p_cb_list_box.p_Noflines == 0)
    {
        p_window_id.p_cb_text_box.p_text = "(None)";
    }
    else
    {
        p_window_id.p_cb_text_box.p_text = "(Select Server)";
    }
}

/**
 * Called whenever a workspace is closed. Check the connection
 * state. If active, force a disconnect.
 */
void _wkspace_close_remoteserver()
{
    if (_rs_connect_state > 0)
    {
        _rsDisconnect();
    }
}

/**
 * Called whenever a project is closed. Check the connection
 * state. If active, force a disconnect.
 */
int _prjclose_remoteserver()
{
    if (_rs_connect_state > 0)
    {
        _rsDisconnect();
    }
    return 0;
}

/**
 * Retrieve the command line for a given project Tool/Command.
 */
_str get_project_command(_str command)
{
    int handle = _ProjectHandle();
    if (handle < 0)
    {
        return null;
    }

    int target = _ProjectGet_TargetNode(handle, command);
    if (target < 0)
    {
        return null;
    }

    return _ProjectGet_TargetCmdLine(handle, target);
}

/**
 * Retrieve the value of a SynSetting in the project file.
 */
typeless get_synsetting_value(_str name)
{
    int handle = _ProjectHandle();
    if (handle < 0)
    {
        return null;
    }

    _str config = GetCurrentConfigName();
    if (config == null || config == "")
    {
        return null;
    }

    int synsetting = _xmlcfg_find_simple(handle,VPJX_CONFIG :+ "[strieq(@Name,'" :+ config :+ "')]/" :+\
                                         "SynSettings/SynSetting[strieq(@Name,'" :+ name :+ "')]");
    if (synsetting < 0)
    {
        return null;
    }

    return _xmlcfg_get_attribute(handle, synsetting, "Value", "");
}


/**
 * Begin the event table for the Remote Server toolbar.
 */
defeventtab _tbRemoteServer;

void current_server(_str name)
{
    _rs_wid.p_parent.server_list.p_cb_text_box.p_text = name;
}

void setup_button.lbutton_up()
{
    // Show the config dialog
    show("-modal _RemoteServerConfig");
    _str host_name = _rs_current_host.name;
    // Hosts may have changed, update the list
    if (server_list.p_enabled)
    {
        server_list.refresh_host_list();
        foreach (auto host in _rs_hosts)
        {
            if (host.name == host_name)
            {
                _rs_current_host = host;
                server_list.SetListText(host_name);
                break;
            }
        }
    }
}

void connect_btn.lbutton_up()
{
    _rs_wid = io_control;
    // Is there even a host selected?
    _str selected_item = server_list.p_cb_list_box._lbget_text();
    if (selected_item == "(None)" || selected_item == "(Select Server)")
    {
        return;
    }

    // Look for a connect handler
    _rsConnect(_rs_current_host.host, _rs_current_host.port);
    if ( client.isConnected() )
    {
       save_last_host();
    }
}

void disconnect_btn.lbutton_up()
{
    _rs_wid = io_control;
    _rsDisconnect();
}

void clear_button.lbutton_up()
{
    empty_buffer();
}

void _tbRemoteServer.on_load()
{
    _rs_wid = io_control;

    if (_rs_connect_state > 0 && _rs_bg_buf._length() > 0 && client.isConnected())
    {
        server_list.p_cb_text_box.p_text = _rs_current_host.name;
        _rsUIConnectedState();
        int i;
        _str line;
        io_control.top();
        for (i = 0; i < _rs_bg_buf._length(); i++)
        {
            if (i == 0)
            {
                io_control.replace_line(_rs_bg_buf[i]);
            }
            else
            {
                io_control.insert_line(_rs_bg_buf[i]);
            }
        }
        io_control.bottom();
        io_control._end_line();
    }
}

void io_control.lbutton_double_click()
{
    _str line;
    get_line(line);

    _str filename;
    _str error_data;
    _str error_line;

    parse line with "\"" filename "\"" "(" error_line "):" error_data;

    if (filename._length() > 0 && error_line._length() > 0)
    {
        int i;

        for (i = 1; i <= error_line._length(); i++)
        {
            if (!isdigit(_charAt(error_line, i)))
            {
                // If error_line isn't a number, just exit
                return;
            }
        }
        int status = edit("+W "filename);
        if (!status)
        {
            p_line = (int)error_line;
        }
    }

}

void io_control.'C-A'-'C-B','C-D'-'C-U','C-W','C-Y'()
{
    return;
}

void io_control.'C-Z','S-BACKSPACE','C-HOME','S-UP','S-DOWN'()
{
    return;
}

void io_control.'C-BACKSPACE'()
{
    if (p_line == p_Noflines)
    {
        cut_line();
        insert_line("$");
        end_line();
    }
}

void io_control.'HOME'()
{
    if (p_line == p_Noflines)
    {
        p_col = 2;
    }
}

void io_control.'S-HOME'()
{
    _str line;
    get_line(line);
    if (p_line == p_Noflines && line._length() > 1)
    {
        replace_line(substr(line, 2));
        cua_select();
        begin_line();
        _insert_text("$");
    }
}

void io_control.'ENTER'()
{
    if (_rs_connect_state == 0)
    {
        return;
    }
    SendCommand();
}

void io_control.'UP'()
{
    if (p_line == p_Noflines && _rs_command_history._length() > 0)
    {
        _str line = "$" :+ _rs_command_history[_rs_hist_num];
        replace_line(line);
        end_line();
        _rs_hist_num--;
        if (_rs_hist_num < 0)
        {
            _rs_hist_num = _rs_command_history._length() - 1;
        }
    }
}

void io_control.'DOWN'()
{
    if (p_line == p_Noflines && _rs_command_history._length() > 0)
    {
        _rs_hist_num++;
        if (_rs_hist_num > _rs_command_history._length() - 1)
        {
            _rs_hist_num = 0;
        }
        _str line = "$" :+ _rs_command_history[_rs_hist_num];
        replace_line(line);
        end_line();
    }
}

void io_control.'S-LEFT'()
{
    _str line;
    get_line(line);
    if (p_col == 2 && p_line == p_Noflines && line._length() > 0)
    {
        return;
    }
    else
    {
        cua_select();
    }
}

void io_control.'LEFT'()
{
    _str line;
    get_line(line);
    if (p_col == 2 && p_line == p_Noflines && line._length() > 0)
    {
        return;
    }
    else
    {
        p_col--;
    }
}

void io_control.'RIGHT'()
{
    _str line;
    get_line(line);
    if (p_col > line._length())
    {
        return;
    }
    else
    {
        p_col++;
    }
}

void io_control.'BACKSPACE'()
{
    _str line;
    get_line(line);
    if (p_col == 2 && line._length() > 0 && substr(line, 1, 1) == "$")
    {
        return;
    }
    else
    {
        linewrap_rubout();
    }
}

/**
 * Take all the lines under the Command Line label and stick
 * them into a CRLF delimited string. If we can call the
 * _rsCommand handler, pass the command string, local drive map
 * and remote drive map onward and delete the rows from the box.
 */
void SendCommand()
{
    int i;
    _str data = "";
    _str line;

    get_line(data);
    data = substr(data, 2);
    if (strip(data) == "")
    {
        return;
    }

    _rs_command_history[_rs_command_history._length()] = data;
    _rs_hist_num = _rs_command_history._length() - 1;

    if (lowcase(data) == "cls")
    {
        empty_buffer();
        return;
    }

    // Call it if we can and pass the additional data
    _rsCommand(data);

}

void setup_button.on_create()
{
    server_list.refresh_host_list();
    _rs_loaded = 1;
    if (server_list.p_cb_list_box.p_Noflines > 0)
    {
        restore_last_host();
    }
}
void _tbRemoteServer.on_destroy()
{
    _rs_loaded = 0;
    return;
}

// Resize handler to deal with being a toolbar
// Taken from a SlickEdit toolbar and modified
void _tbRemoteServer.on_resize()
{
    _nocheck _control io_control;
    _nocheck _control server_label;
    _nocheck _control server_list;
    _nocheck _control connect_btn;
    _nocheck _control disconnect_btn;
    _nocheck _control setup_button;
    typeless remoteserver = p_window_id;

    int clientW = _dx2lx(p_active_form.p_xyscale_mode,p_active_form.p_client_width);
    int clientH = _dy2ly(p_active_form.p_xyscale_mode,p_active_form.p_client_height);

    io_control.p_width = clientW - 2 * io_control.p_x;
    io_control.p_height = clientH - io_control.p_y - io_control.p_x - 401;

    int y_pos = io_control.p_height + 150;
    server_label.p_y = y_pos + 25;
    server_list.p_y = y_pos;
    connect_btn.p_y = y_pos;
    disconnect_btn.p_y = y_pos;
    setup_button.p_y = y_pos;
    clear_button.p_y = y_pos;
}

void _tbRemoteServer.on_got_focus()
{
    return;
}

// Handle combo box changes to set the current host
void server_list.on_change(int reason)
{
    _str selected_item = server_list.p_cb_list_box._lbget_text();
    if (selected_item._length() < 1)
    {
        return;
    }

    foreach (auto host in _rs_hosts)
    {
        if (selected_item == host.name)
        {
            _rs_current_host = host;
            break;
        }
    }
}

_tbRemoteServer.on_destroy()
{
    _str line;
    _rs_bg_buf = null;
    io_control.top();
    do
    {
        io_control.get_line(line);
        _rs_bg_buf[_rs_bg_buf._length()] = line;
    } while (!io_control.down());
    call_event(p_window_id, ON_DESTROY, '2');
}

_tbRemoteServer.on_create()
{
    toolbarRestoreState();
}

void io_control.on_got_focus()
{
    _rs_wid = io_control;
}

void io_control.on_create()
{
    _rs_wid = io_control;
}

// Begin event table for Remote Server Setup window
defeventtab _RemoteServerConfig;

#define _RS_CONFIG_DEFAULT  0
#define _RS_CONFIG_NEW      1
#define _RS_CONFIG_EDIT     2
#define _RS_CONFIG_SELECTED 3

static int _rs_config_state = _RS_CONFIG_DEFAULT;
static _str _rs_config_name = "";

void SetButtonFieldStates()
{
    switch (_rs_config_state)
    {
        case _RS_CONFIG_DEFAULT:
            ctlbtn_edit.p_enabled = false;
            ctlbtn_new.p_enabled = true;
            ctlbtn_save.p_enabled = false;
            ctlbtn_remove.p_enabled = false;
            break;
        case _RS_CONFIG_NEW:
            ctlbtn_edit.p_enabled = false;
            ctlbtn_new.p_enabled = true;
            ctlbtn_save.p_enabled = true;
            ctlbtn_remove.p_enabled = false;
            break;
        case _RS_CONFIG_EDIT:
            ctlbtn_edit.p_enabled = false;
            ctlbtn_new.p_enabled = true;
            ctlbtn_save.p_enabled = true;
            ctlbtn_remove.p_enabled = true;
            break;
        case _RS_CONFIG_SELECTED:
            ctlbtn_edit.p_enabled = true;
            ctlbtn_new.p_enabled = true;
            ctlbtn_save.p_enabled = false;
            ctlbtn_remove.p_enabled = true;
            break;
    }
}

void SetTextFieldStates(boolean enabled)
{
    ctltxt_name.p_enabled = enabled;
    ctltxt_host.p_enabled = enabled;
    ctltxt_port.p_enabled = enabled;
    ctltxt_localmap.p_enabled = enabled;
    ctltxt_remotemap.p_enabled = enabled;
}

void ctlbtn_new.lbutton_up()
{
    if (_rs_config_state == _RS_CONFIG_NEW || _rs_config_state == _RS_CONFIG_EDIT)
    {
        if (!AbandonChanges())
        {
            return;
        }
    }
    _rs_config_name = "";
    _rs_config_state = _RS_CONFIG_NEW;
    SetButtonFieldStates();
    SetTextFieldStates(true);
    EmptyFields();
    ctlcbo_list.SetListText("(New Item)");
}

void ctlbtn_edit.lbutton_up()
{
    _rs_config_state = _RS_CONFIG_EDIT;
    SetButtonFieldStates();
    SetTextFieldStates(true);
}

boolean AbandonChanges()
{
    typeless sts = _message_box("Do you want to abandon changes?", "Remote Server", MB_YESNOCANCEL|MB_ICONEXCLAMATION);
    if (sts == IDYES)
    {
        return true;
    }
    return false;
}

boolean ConfirmRemove(_str name)
{
    typeless sts = _message_box("Are you sure that you want to remove "name"?", "Remote Server", MB_YESNOCANCEL|MB_ICONEXCLAMATION);
    if (sts == IDYES)
    {
        return true;
    }
    return false;
}

void SetListText(_str text)
{
    p_window_id.p_cb_text_box.p_text = text;
}

void SelectHost(_str name)
{
    foreach (auto host in _rs_hosts)
    {
        if (name == host.name)
        {
            ctltxt_name.p_text = host.name;
            ctltxt_host.p_text = host.host;
            ctltxt_port.p_text = host.port;
            ctltxt_localmap.p_text = host.local_map;
            ctltxt_remotemap.p_text = host.remote_map;
            _rs_config_name = name;
            break;
        }
    }
}

void ctltxt_name.'(',')'()
{
    return;
}

void ctltxt_port.'ENTER'()
{
    SaveEntry();
}

void ctltxt_remotemap.'ENTER'()
{
    SaveEntry();
}

void ctltxt_port.'A'-'Z','a'-'z'()
{
    return;
}

void _RemoteServerConfig.'ESC'()
{
    ExitConfig();
}

void ctlbtn_save.lbutton_up()
{
    SaveEntry();
}

void ctlbtn_close.lbutton_up()
{
    ExitConfig();
}

void ExitConfig()
{
    if (_rs_config_state == _RS_CONFIG_NEW || _rs_config_state == _RS_CONFIG_EDIT)
    {
        if (!AbandonChanges())
        {
            return;
        }
    }

    p_active_form._delete_window(0);
}

void ctlbtn_remove.lbutton_up()
{
    _str selected_item = ctlcbo_list.p_cb_list_box._lbget_text();
    if (!ConfirmRemove(selected_item))
    {
        return;
    }
    RemoveHost(selected_item);
    EmptyFields();

    _rs_config_state = _RS_CONFIG_DEFAULT;
    SetButtonFieldStates();
    SetTextFieldStates(false);
    ctlcbo_list.refresh_host_list();
}

void RemoveHost(_str name)
{
    if (name._length() > 0)
    {
        int i = 0;
        boolean found_match = false;
        for (i = 0; i < _rs_hosts._length(); i++)
        {
            if (_rs_hosts[i].name == name)
            {

                _rs_hosts._deleteel(i);
                break;
            }
        }
    }
    save_hosts();
}

void ctlbtn_save.on_create()
{
    _rs_config_state = _RS_CONFIG_DEFAULT;
    ctlcbo_list.refresh_host_list();
    EmptyFields();
    if (_rs_current_host.name != "")
    {
        _rs_config_state = _RS_CONFIG_SELECTED;
        SetButtonFieldStates();
        SelectHost(_rs_current_host.name);
        ctlcbo_list.SetListText(_rs_current_host.name);
    }
}

void ctlcbo_list.on_change(int reason)
{
    if (reason == CHANGE_OTHER)
    {
        return;
    }

    if (_rs_config_state == _RS_CONFIG_NEW || _rs_config_state == _RS_CONFIG_EDIT)
    {
        if (!AbandonChanges())
        {
            return;
        }
    }

    _str selected_item = ctlcbo_list.p_cb_list_box._lbget_text();
    if (selected_item._length() < 1)
    {
        return;
    }

    _rs_config_state = _RS_CONFIG_SELECTED;
    SetButtonFieldStates();
    SetTextFieldStates(false);
    SelectHost(selected_item);
}

void SaveEntry()
{
    if (ctltxt_name.p_text._length() < 1)
    {
        return;
    }

    _str name = ctltxt_name.p_text;
    if (_rs_config_name._length() > 0 && name != _rs_config_name)
    {
        RemoveHost(_rs_config_name);
    }
    ctltxt_name.p_text = strip(ctltxt_name.p_text);
    boolean match_found = false;
    int i;
    for (i = 0; i < _rs_hosts._length(); i++)
    {
        _RS_HOST host = _rs_hosts[i];
        if (host.name == ctltxt_name.p_text)
        {
            match_found = true;
            host.name = ctltxt_name.p_text;
            host.host = ctltxt_host.p_text;
            if (ctltxt_port.p_text._length() > 0)
                host.port = (int)ctltxt_port.p_text;
            else
                host.port = 0;
            host.local_map = ctltxt_localmap.p_text;
            host.remote_map = ctltxt_remotemap.p_text;
            _rs_hosts[i] = host;
            break;
        }
    }
    if (!match_found)
    {
        _RS_HOST new_host;
        new_host.name = ctltxt_name.p_text;
        new_host.host = ctltxt_host.p_text;
        if (ctltxt_port.p_text._length() > 0)
            new_host.port = (int)ctltxt_port.p_text;
        else
            new_host.port = 0;
        new_host.local_map = ctltxt_localmap.p_text;
        new_host.remote_map = ctltxt_remotemap.p_text;

        _rs_hosts[_rs_hosts._length()] = new_host;
    }
    save_hosts();
    if (!match_found)
    {
        ctlcbo_list.refresh_host_list();
    }

    EmptyFields();
    _rs_config_state = _RS_CONFIG_SELECTED;
    SetButtonFieldStates();
    SetTextFieldStates(false);
    SelectHost(name);
    ctlcbo_list.SetListText(name);
}

void EmptyFields()
{
    ctltxt_name.p_text = "";
    ctltxt_host.p_text = "";
    ctltxt_port.p_text = "";
    ctltxt_localmap.p_text = "";
    ctltxt_remotemap.p_text = "";
}

boolean DeconstructToolbar()
{

    int wid = _tbGetWid(TBREMOTESERVER);
    if (wid <= 0)
    {
        return false;
    }

    tbHide(TBREMOTESERVER);

    int len = def_toolbartab._length();
    int i = 0;

    for (i = 0; i < len; i++)
    {
        if (def_toolbartab[i].FormName == TBREMOTESERVER)
        {
            def_toolbartab[i] = null;
            return true;
        }
    }

    return true;
}

/**
 * Make sure that the Remote Server toolbar has been added to
 * SlickEdit's toolbar table. Otherwise we will not show up in
 * the View > Tool Windows list.
 */
definit()
{
    _rs_wid = 0;
    InitRemoteServerToolbar();
}

void InitRemoteServerToolbar()
{
    int len = def_toolbartab._length();
    int i = 0;

    for (i = 0; i < len; i++)
    {
       if (def_toolbartab[i].FormName == TBREMOTESERVER)
       {
           return;
       }
    }

    def_toolbartab[len] = TBRemoteServer;
}

_command void CodeGen_ShowToolbar() name_info(',')
{
    tbShow(TBREMOTESERVER);
}

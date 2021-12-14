
_form _tbRemoteServer {
   p_backcolor=0x80000005;
   p_border_style=BDS_SIZABLE;
   p_caption='Remote Server';
   p_CaptionClick=true;
   p_clip_controls=true;
   p_forecolor=0x80000008;
   p_height=3675;
   p_picture='otshell.bmp';
   p_tool_window=true;
   p_width=9795;
   p_x=6420;
   p_y=2925;
   p_eventtab=_tbRemoteServer;
   p_eventtab2=_toolbar_etab2;
   _label server_label {
      p_alignment=AL_LEFT;
      p_auto_size=false;
      p_backcolor=0x80000005;
      p_border_style=BDS_NONE;
      p_caption='Remote Server:';
      p_forecolor=0x80000008;
      p_height=240;
      p_tab_index=0;
      p_width=1170;
      p_word_wrap=false;
      p_x=90;
      p_y=3205;
   }
   _editor io_control {
      p_auto_size=false;
      p_backcolor=0x80000005;
      p_border_style=BDS_FIXED_SINGLE;
      p_enabled=false;
      p_height=2760;
      p_scroll_bars=SB_BOTH;
      p_tab_index=1;
      p_tab_stop=true;
      p_width=6240;
      p_x=60;
      p_y=60;
      p_eventtab2=_ul2_editwin;
   }
   _combo_box server_list {
      p_auto_size=true;
      p_backcolor=0x80000005;
      p_case_sensitive=false;
      p_completion=NONE_ARG;
      p_forecolor=0x80000008;
      p_height=285;
      p_style=PSCBO_EDIT;
      p_tab_index=2;
      p_tab_stop=true;
      p_width=1740;
      p_x=1320;
      p_y=3120;
      p_eventtab2=_ul2_combobx;
   }
   _command_button connect_btn {
      p_cancel=false;
      p_caption='Connect';
      p_default=false;
      p_height=300;
      p_tab_index=3;
      p_tab_stop=true;
      p_width=900;
      p_x=3180;
      p_y=3105;
   }
   _command_button disconnect_btn {
      p_cancel=false;
      p_caption='Disconnect';
      p_default=false;
      p_height=300;
      p_tab_index=4;
      p_tab_stop=true;
      p_visible=false;
      p_width=900;
      p_x=3180;
      p_y=3105;
   }
   _command_button setup_button {
      p_cancel=false;
      p_caption='Setup...';
      p_default=false;
      p_height=300;
      p_tab_index=5;
      p_tab_stop=true;
      p_width=885;
      p_x=4140;
      p_y=3105;
   }
   _command_button clear_button {
      p_cancel=false;
      p_caption='Clear';
      p_default=false;
      p_height=300;
      p_tab_index=6;
      p_tab_stop=true;
      p_width=900;
      p_x=5100;
      p_y=3105;
      p_eventtab=_tbRemoteServer.clear_button;
   }
}

_form _RemoteServerConfig {
   p_backcolor=0x80000005;
   p_border_style=BDS_DIALOG_BOX;
   p_caption='Remote Server Setup';
   p_clip_controls=false;
   p_forecolor=0x80000008;
   p_height=3600;
   p_width=4620;
   p_x=8520;
   p_y=6615;
   p_eventtab=_RemoteServerConfig;
   _combo_box ctlcbo_list {
      p_auto_size=true;
      p_backcolor=0x80000005;
      p_case_sensitive=false;
      p_completion=NONE_ARG;
      p_forecolor=0x80000008;
      p_height=285;
      p_style=PSCBO_EDIT;
      p_tab_index=1;
      p_tab_stop=true;
      p_width=2655;
      p_x=225;
      p_y=180;
      p_eventtab2=_ul2_combobx;
   }
   _command_button ctlbtn_new {
      p_cancel=false;
      p_caption='&New';
      p_default=false;
      p_height=300;
      p_tab_index=2;
      p_tab_stop=true;
      p_width=660;
      p_x=2970;
      p_y=180;
      p_eventtab=_RemoteServerConfig.ctlbtn_new;
   }
   _command_button ctlbtn_edit {
      p_cancel=false;
      p_caption='&Edit';
      p_default=false;
      p_enabled=false;
      p_height=300;
      p_tab_index=3;
      p_tab_stop=true;
      p_width=660;
      p_x=3690;
      p_y=180;
      p_eventtab=_RemoteServerConfig.ctlbtn_edit;
   }
   _frame ctlframe1 {
      p_backcolor=0x80000005;
      p_caption='Server Setup';
      p_clip_controls=true;
      p_forecolor=0x80000008;
      p_height=2280;
      p_tab_index=4;
      p_width=4155;
      p_x=225;
      p_y=630;
      _label ctllabel1 {
         p_alignment=AL_LEFT;
         p_auto_size=false;
         p_backcolor=0x80000005;
         p_border_style=BDS_NONE;
         p_caption='Host';
         p_forecolor=0x80000008;
         p_height=240;
         p_tab_index=1;
         p_width=420;
         p_word_wrap=false;
         p_x=180;
         p_y=870;
      }
      _label ctllabel2 {
         p_alignment=AL_LEFT;
         p_auto_size=false;
         p_backcolor=0x80000005;
         p_border_style=BDS_NONE;
         p_caption='Port';
         p_forecolor=0x80000008;
         p_height=240;
         p_tab_index=2;
         p_width=360;
         p_word_wrap=false;
         p_x=2820;
         p_y=870;
      }
      _text_box ctltxt_name {
         p_auto_size=true;
         p_backcolor=0x80000005;
         p_border_style=BDS_FIXED_SINGLE;
         p_completion=NONE_ARG;
         p_enabled=false;
         p_forecolor=0x80000008;
         p_height=255;
         p_tab_index=3;
         p_tab_stop=true;
         p_width=3180;
         p_x=660;
         p_y=480;
         p_eventtab2=_ul2_textbox;
      }
      _text_box ctltxt_host {
         p_auto_size=true;
         p_backcolor=0x80000005;
         p_border_style=BDS_FIXED_SINGLE;
         p_completion=NONE_ARG;
         p_enabled=false;
         p_forecolor=0x80000008;
         p_height=255;
         p_tab_index=4;
         p_tab_stop=true;
         p_width=1980;
         p_x=660;
         p_y=855;
         p_eventtab2=_ul2_textbox;
      }
      _text_box ctltxt_port {
         p_auto_size=true;
         p_backcolor=0x80000005;
         p_border_style=BDS_FIXED_SINGLE;
         p_completion=NONE_ARG;
         p_enabled=false;
         p_forecolor=0x80000008;
         p_height=255;
         p_tab_index=5;
         p_tab_stop=true;
         p_width=600;
         p_x=3240;
         p_y=855;
         p_eventtab2=_ul2_textbox;
      }
      _text_box ctltxt_localmap {
         p_auto_size=true;
         p_backcolor=0x80000005;
         p_border_style=BDS_FIXED_SINGLE;
         p_completion=NONE_ARG;
         p_enabled=false;
         p_forecolor=0x80000008;
         p_height=255;
         p_tab_index=6;
         p_tab_stop=true;
         p_width=2520;
         p_x=1320;
         p_y=1230;
         p_eventtab2=_ul2_textbox;
      }
      _text_box ctltxt_remotemap {
         p_auto_size=true;
         p_backcolor=0x80000005;
         p_border_style=BDS_FIXED_SINGLE;
         p_completion=NONE_ARG;
         p_enabled=false;
         p_forecolor=0x80000008;
         p_height=255;
         p_tab_index=7;
         p_tab_stop=true;
         p_width=2520;
         p_x=1320;
         p_y=1605;
         p_eventtab2=_ul2_textbox;
      }
      _label ctllabel3 {
         p_alignment=AL_LEFT;
         p_auto_size=false;
         p_backcolor=0x80000005;
         p_border_style=BDS_NONE;
         p_caption='Name';
         p_forecolor=0x80000008;
         p_height=240;
         p_tab_index=8;
         p_width=420;
         p_word_wrap=false;
         p_x=180;
         p_y=495;
      }
      _label ctllabel4 {
         p_alignment=AL_LEFT;
         p_auto_size=false;
         p_backcolor=0x80000005;
         p_border_style=BDS_NONE;
         p_caption='Local Map';
         p_forecolor=0x80000008;
         p_height=300;
         p_tab_index=9;
         p_width=780;
         p_word_wrap=false;
         p_x=180;
         p_y=1245;
      }
      _label ctllabel5 {
         p_alignment=AL_LEFT;
         p_auto_size=false;
         p_backcolor=0x80000005;
         p_border_style=BDS_NONE;
         p_caption='Remote Map';
         p_forecolor=0x80000008;
         p_height=300;
         p_tab_index=10;
         p_width=960;
         p_word_wrap=false;
         p_x=180;
         p_y=1620;
      }
   }
   _command_button ctlbtn_save {
      p_cancel=false;
      p_caption='&Save';
      p_default=false;
      p_enabled=false;
      p_height=360;
      p_tab_index=5;
      p_tab_stop=true;
      p_width=840;
      p_x=225;
      p_y=3060;
      p_eventtab=_RemoteServerConfig.ctlbtn_save;
   }
   _command_button ctlbtn_remove {
      p_cancel=false;
      p_caption='&Remove';
      p_default=false;
      p_enabled=false;
      p_height=360;
      p_tab_index=6;
      p_tab_stop=true;
      p_width=840;
      p_x=1125;
      p_y=3060;
      p_eventtab=_RemoteServerConfig.ctlbtn_remove;
   }
   _command_button ctlbtn_close {
      p_cancel=true;
      p_caption='&Close';
      p_default=false;
      p_height=360;
      p_tab_index=7;
      p_tab_stop=true;
      p_width=840;
      p_x=3555;
      p_y=3060;
      p_eventtab=_RemoteServerConfig.ctlbtn_close;
   }
}



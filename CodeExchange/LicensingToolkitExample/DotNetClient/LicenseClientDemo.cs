using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace lct
{
    public partial class LicenseClientDemo : Form
    {
        Timer timer = new Timer();
        List<int> apTokens = new List<int>();
        List<int> arTokens = new List<int>();
        List<int> glTokens = new List<int>();
        List<int> faTokens = new List<int>();
        List<int> inTokens = new List<int>();

        public LicenseClientDemo()
        {
            InitializeComponent();
            timer.Interval = 500; //Milliseconds
            timer.Tick += new EventHandler(timer_Tick);
            grdStatus.Rows.Add(new object[] { "Accounts Payable", "AP010", "0" });
            grdStatus.Rows.Add(new object[] { "Accounts Receivable", "AR010", "0" });
            grdStatus.Rows.Add(new object[] { "General Ledger", "GL010", "0" });
            grdStatus.Rows.Add(new object[] { "Fixed Assets", "FA010", "0" });
            grdStatus.Rows.Add(new object[] { "Inventory", "IN010", "0" });
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            //Try any operation to make sure we can talk to the license server
            try
            {
                int x = LicensingToolkit.LicenseUsage("AP010");
                timer.Start();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message,"Error");
                this.Close();
            }

        }

        private void chkAutoUpdate_CheckedChanged(object sender, EventArgs e)
        {
            btnUpdateStatus.Enabled = !chkAutoUpdate.Checked;
            if (chkAutoUpdate.Checked)
                timer.Start();
            else
                timer.Stop();
        
        }

        private void btnLoginAll_Click(object sender, EventArgs e)
        {
            doLoginAll();
        }

        private void btnLogoutAll_Click(object sender, EventArgs e)
        {
            doLogoutAll();
        }

        private void btnClose_Click(object sender, EventArgs e)
        {
            doLogoutAll();
            this.Close();
        }


        private void timer_Tick(object sender, EventArgs e)
        {
            doStatusUpdate();
        }

        private void btnUpdateStatus_Click(object sender, EventArgs e)
        {
            doStatusUpdate();
        }

        private void grdStatus_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            string licenseCode = grdStatus.Rows[e.RowIndex].Cells[1].Value.ToString();

            switch (e.ColumnIndex)
            {
                case 3: //Login
                    doLogin(licenseCode,true);
                    break;
                case 4: //Logout
                    doLogout(licenseCode,true);
                    break;
            }
        }

        private bool doLogin(string licenseCode, bool displayError)
        {
            bool status = false;
            List<int> tokens = selectTokenCollection(licenseCode);
            int myToken = 0;
            int mySeat = 0;
            string statusText = "";

            if (chkUseSeats.Checked)
                mySeat = tokens.Count + 1;

            if (LicensingToolkit.Login(licenseCode, mySeat, ref myToken, ref statusText))
            {
                tokens.Add(myToken);
                status = true;
            }
            else
            {
                if (displayError)
                    MessageBox.Show(statusText);
            }
            return status;
        }

        private bool doLogout(string licenseCode, bool displayError)
        {
            bool status = false;
            List<int> tokens = selectTokenCollection(licenseCode);
            if (tokens.Count > 0)
            {
                int mySeat = 0;
                int myToken = 0;
                string statusText = "";

                myToken = tokens[tokens.Count - 1];

                if (chkUseSeats.Checked)
                    mySeat = tokens.Count;

                if (LicensingToolkit.Logout(licenseCode, mySeat, myToken, ref statusText))
                {
                    tokens.RemoveAt(tokens.Count - 1);
                    status = true;
                }
                else
                {
                    if (displayError)
                        MessageBox.Show(statusText);
                }
            }
            return status;
        }

        private List<int> selectTokenCollection(string licenseCode)
        {
            switch (licenseCode)
            {
                case "AP010":
                    return apTokens;
                case "AR010":
                    return arTokens;
                case "GL010":
                    return glTokens;
                case "FA010":
                    return faTokens;
                case "IN010":
                    return inTokens;
            }
            return null;
        }

        private void doStatusUpdate()
        {
            try
            {
                grdStatus.Rows[0].Cells[2].Value = LicensingToolkit.LicenseUsage("AP010");
                grdStatus.Rows[1].Cells[2].Value = LicensingToolkit.LicenseUsage("AR010");
                grdStatus.Rows[2].Cells[2].Value = LicensingToolkit.LicenseUsage("GL010");
                grdStatus.Rows[3].Cells[2].Value = LicensingToolkit.LicenseUsage("FA010");
                grdStatus.Rows[4].Cells[2].Value = LicensingToolkit.LicenseUsage("IN010");
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Error");
            }
        }

        private void doLoginAll()
        {
            while (doLogin("AP010", false))
            {
            }
            while (doLogin("AR010", false))
            {
            }
            while (doLogin("GL010", false))
            {
            }
            while (doLogin("FA010", false))
            {
            }
            while (doLogin("IN010", false))
            {
            }
        }

        private void doLogoutAll()
        {
            while (doLogout("AP010", false))
            {
            }
            while (doLogout("AR010", false))
            {
            }
            while (doLogout("GL010", false))
            {
            }
            while (doLogout("FA010", false))
            {
            }
            while (doLogout("IN010", false))
            {
            }
        }

    }

}

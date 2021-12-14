namespace lct
{
    partial class LicenseClientDemo
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(LicenseClientDemo));
            this.grdStatus = new System.Windows.Forms.DataGridView();
            this.AppName = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.AppCode = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.CurrentUsage = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.BtnAdd = new System.Windows.Forms.DataGridViewButtonColumn();
            this.BtnRemove = new System.Windows.Forms.DataGridViewButtonColumn();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.btnUpdateStatus = new System.Windows.Forms.Button();
            this.chkAutoUpdate = new System.Windows.Forms.CheckBox();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.chkUseSeats = new System.Windows.Forms.CheckBox();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.btnClose = new System.Windows.Forms.Button();
            this.btnLogoutAll = new System.Windows.Forms.Button();
            this.btnLoginAll = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.grdStatus)).BeginInit();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.SuspendLayout();
            // 
            // grdStatus
            // 
            this.grdStatus.AllowUserToAddRows = false;
            this.grdStatus.AllowUserToDeleteRows = false;
            this.grdStatus.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.grdStatus.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.grdStatus.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.AppName,
            this.AppCode,
            this.CurrentUsage,
            this.BtnAdd,
            this.BtnRemove});
            this.grdStatus.Location = new System.Drawing.Point(12, 12);
            this.grdStatus.Name = "grdStatus";
            this.grdStatus.ReadOnly = true;
            this.grdStatus.RowHeadersVisible = false;
            this.grdStatus.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.grdStatus.Size = new System.Drawing.Size(645, 150);
            this.grdStatus.TabIndex = 4;
            this.grdStatus.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.grdStatus_CellContentClick);
            // 
            // AppName
            // 
            this.AppName.HeaderText = "Application Name";
            this.AppName.Name = "AppName";
            this.AppName.ReadOnly = true;
            // 
            // AppCode
            // 
            this.AppCode.HeaderText = "License Code";
            this.AppCode.Name = "AppCode";
            this.AppCode.ReadOnly = true;
            // 
            // CurrentUsage
            // 
            this.CurrentUsage.HeaderText = "Current Usage";
            this.CurrentUsage.Name = "CurrentUsage";
            this.CurrentUsage.ReadOnly = true;
            // 
            // BtnAdd
            // 
            this.BtnAdd.HeaderText = "";
            this.BtnAdd.Name = "BtnAdd";
            this.BtnAdd.ReadOnly = true;
            this.BtnAdd.Text = "Login";
            this.BtnAdd.UseColumnTextForButtonValue = true;
            // 
            // BtnRemove
            // 
            this.BtnRemove.HeaderText = "";
            this.BtnRemove.Name = "BtnRemove";
            this.BtnRemove.ReadOnly = true;
            this.BtnRemove.Text = "Logout";
            this.BtnRemove.UseColumnTextForButtonValue = true;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.btnUpdateStatus);
            this.groupBox1.Controls.Add(this.chkAutoUpdate);
            this.groupBox1.Location = new System.Drawing.Point(12, 168);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(173, 75);
            this.groupBox1.TabIndex = 5;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Status Updates";
            // 
            // btnUpdateStatus
            // 
            this.btnUpdateStatus.Enabled = false;
            this.btnUpdateStatus.Location = new System.Drawing.Point(57, 42);
            this.btnUpdateStatus.Name = "btnUpdateStatus";
            this.btnUpdateStatus.Size = new System.Drawing.Size(75, 23);
            this.btnUpdateStatus.TabIndex = 1;
            this.btnUpdateStatus.Text = "Update Now";
            this.btnUpdateStatus.UseVisualStyleBackColor = true;
            this.btnUpdateStatus.Click += new System.EventHandler(this.btnUpdateStatus_Click);
            // 
            // chkAutoUpdate
            // 
            this.chkAutoUpdate.AutoSize = true;
            this.chkAutoUpdate.Checked = true;
            this.chkAutoUpdate.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chkAutoUpdate.Location = new System.Drawing.Point(18, 19);
            this.chkAutoUpdate.Name = "chkAutoUpdate";
            this.chkAutoUpdate.Size = new System.Drawing.Size(140, 17);
            this.chkAutoUpdate.TabIndex = 0;
            this.chkAutoUpdate.Text = "Automatic status update";
            this.chkAutoUpdate.UseVisualStyleBackColor = true;
            this.chkAutoUpdate.CheckedChanged += new System.EventHandler(this.chkAutoUpdate_CheckedChanged);
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.chkUseSeats);
            this.groupBox2.Location = new System.Drawing.Point(191, 168);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(182, 75);
            this.groupBox2.TabIndex = 6;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "License Allocation";
            // 
            // chkUseSeats
            // 
            this.chkUseSeats.AutoSize = true;
            this.chkUseSeats.Checked = true;
            this.chkUseSeats.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chkUseSeats.Location = new System.Drawing.Point(20, 19);
            this.chkUseSeats.Name = "chkUseSeats";
            this.chkUseSeats.Size = new System.Drawing.Size(146, 17);
            this.chkUseSeats.TabIndex = 4;
            this.chkUseSeats.Text = "Use unique seat numbers";
            this.chkUseSeats.UseVisualStyleBackColor = true;
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.btnClose);
            this.groupBox3.Controls.Add(this.btnLogoutAll);
            this.groupBox3.Controls.Add(this.btnLoginAll);
            this.groupBox3.Location = new System.Drawing.Point(394, 168);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(263, 75);
            this.groupBox3.TabIndex = 7;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "Tools";
            // 
            // btnClose
            // 
            this.btnClose.Location = new System.Drawing.Point(173, 15);
            this.btnClose.Name = "btnClose";
            this.btnClose.Size = new System.Drawing.Size(75, 23);
            this.btnClose.TabIndex = 2;
            this.btnClose.Text = "Close";
            this.btnClose.UseVisualStyleBackColor = true;
            this.btnClose.Click += new System.EventHandler(this.btnClose_Click);
            // 
            // btnLogoutAll
            // 
            this.btnLogoutAll.Location = new System.Drawing.Point(92, 15);
            this.btnLogoutAll.Name = "btnLogoutAll";
            this.btnLogoutAll.Size = new System.Drawing.Size(75, 23);
            this.btnLogoutAll.TabIndex = 1;
            this.btnLogoutAll.Text = "Logout All";
            this.btnLogoutAll.UseVisualStyleBackColor = true;
            this.btnLogoutAll.Click += new System.EventHandler(this.btnLogoutAll_Click);
            // 
            // btnLoginAll
            // 
            this.btnLoginAll.Location = new System.Drawing.Point(11, 15);
            this.btnLoginAll.Name = "btnLoginAll";
            this.btnLoginAll.Size = new System.Drawing.Size(75, 23);
            this.btnLoginAll.TabIndex = 0;
            this.btnLoginAll.Text = "Login All";
            this.btnLoginAll.UseVisualStyleBackColor = true;
            this.btnLoginAll.Click += new System.EventHandler(this.btnLoginAll_Click);
            // 
            // LicenseClientDemo
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(669, 253);
            this.Controls.Add(this.groupBox3);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.grdStatus);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Margin = new System.Windows.Forms.Padding(2);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "LicenseClientDemo";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Synergy Licensing Toolkit - Example .NET Client";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.grdStatus)).EndInit();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.groupBox3.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.DataGridView grdStatus;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.CheckBox chkAutoUpdate;
        private System.Windows.Forms.Button btnUpdateStatus;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.CheckBox chkUseSeats;
        private System.Windows.Forms.DataGridViewTextBoxColumn AppName;
        private System.Windows.Forms.DataGridViewTextBoxColumn AppCode;
        private System.Windows.Forms.DataGridViewTextBoxColumn CurrentUsage;
        private System.Windows.Forms.DataGridViewButtonColumn BtnAdd;
        private System.Windows.Forms.DataGridViewButtonColumn BtnRemove;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.Button btnLogoutAll;
        private System.Windows.Forms.Button btnLoginAll;
        private System.Windows.Forms.Button btnClose;
    }
}


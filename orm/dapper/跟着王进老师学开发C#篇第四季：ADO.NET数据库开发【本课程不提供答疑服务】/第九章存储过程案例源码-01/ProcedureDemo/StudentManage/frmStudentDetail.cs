using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Models;
using DAL;

namespace StudentManage
{
    public partial class frmStudentDetail : Form
    {
        //定义操作Flag
        private int flag = 0;
        //定义照片路径
        private string path = string.Empty;
        //实例化
        StudentServices objStudentServices = new StudentServices();

        //无参数的构造方法
        public frmStudentDetail()
        {
            InitializeComponent();
        }
        //有参数的构造方法
        public frmStudentDetail(Student objStudent,int actionFlag):this()
        {
            flag = actionFlag;
            switch (flag)
            {
                case 1: //查看
                    LoadViewData(objStudent);
                    break;
                case 2: //添加
                    LoadAddData();
                    break;
                case 3:  //修改
                    LoadUpdateData(objStudent);
                    break;
            }


        }

        public void LoadViewData(Student objStudent)
        {

            //加载数据
            txtSNO.Text = objStudent.SNO.ToString();
            txtName.Text = objStudent.SName;
            if (objStudent.Gender.Contains("男")) rbMale.Checked = true;
            else rbFemale.Checked = true;
            dtpBirthday.Text = objStudent.Birthday.ToString();
            txtMobile.Text = objStudent.Mobile;
            txtEmail.Text = objStudent.Email;
            txtHomeAddress.Text = objStudent.HomeAddress;
            if (string.IsNullOrWhiteSpace(objStudent.PhotoPath))
                pbCurrentPhoto.BackgroundImage = null;
            else
                pbCurrentPhoto.BackgroundImage = Image.FromFile(objStudent.PhotoPath);

            //禁用控件 
            txtSNO.Enabled = false;
            txtName.Enabled = false;
            rbFemale.Enabled = false;
            rbMale.Enabled = false;
            dtpBirthday.Enabled = false;
            txtMobile.Enabled = false;
            txtEmail.Enabled = false;
            txtHomeAddress.Enabled = false;
            btnChoosePhoto.Enabled = false;
            btnCommit.Visible = false;
        }
        public void LoadAddData()
        {
            //把文本框清空
            txtSNO.Text = string.Empty;
            txtName.Text = string.Empty;
            txtMobile.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtHomeAddress.Text = string.Empty;
            pbCurrentPhoto.BackgroundImage = null;
        }
        public void LoadUpdateData(Student objStudent)
        {

            //加载数据
            txtSNO.Text = objStudent.SNO.ToString();
            txtName.Text = objStudent.SName;
            if (objStudent.Gender.Contains("男")) rbMale.Checked = true;
            else rbFemale.Checked = true;
            dtpBirthday.Text = objStudent.Birthday.ToString();
            txtMobile.Text = objStudent.Mobile;
            txtEmail.Text = objStudent.Email;
            txtHomeAddress.Text = objStudent.HomeAddress;
            if (string.IsNullOrWhiteSpace(objStudent.PhotoPath))
                pbCurrentPhoto.BackgroundImage = null;
            else
                pbCurrentPhoto.BackgroundImage = Image.FromFile(objStudent.PhotoPath);

            //学号不允许修改
            txtSNO.Enabled = false;
        }

        private void frmStudentDetail_FormClosing(object sender, FormClosingEventArgs e)
        {
            frmMain.objFrmStudentDetail = null;
        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void btnCommit_Click(object sender, EventArgs e)
        {
            //对输入进行校验 

            //封装Student 
            Student objStudent = new Student
            {
                SNO = Convert.ToInt32(txtSNO.Text),
                SName = txtName.Text.Trim(),
                Gender = rbMale.Checked == true ? "男" : "女",
                Birthday = Convert.ToDateTime(dtpBirthday.Text),
                Mobile = txtMobile.Text.Trim(),
                Email = txtEmail.Text.Trim(),
                HomeAddress = txtHomeAddress.Text.Trim(),
                PhotoPath = string.Empty,
            };
            if (!string.IsNullOrWhiteSpace(path))
                objStudent.PhotoPath = path;

            //执行 
            switch (flag)
            {
                case 2://添加
                    try
                    {
                        if (objStudentServices.AddStudent(objStudent))
                        {
                            //更新到表格
                            this.DialogResult = DialogResult.OK;
                            //显示成功
                            MessageBox.Show("添加学生成功" , "系统消息", MessageBoxButtons.OK, MessageBoxIcon.Information);
                            //关闭当前窗体
                            this.Close();
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show("添加学生失败,具体原因："+ex.Message,"系统消息",MessageBoxButtons.OK,MessageBoxIcon.Information);
                    }
                    break;
                case 3: //修改
                    try
                    {
                        if (objStudentServices.UpdateStudent(objStudent))
                        {
                            //更新到表格
                            this.DialogResult = DialogResult.OK;
                            //显示成功
                            MessageBox.Show("修改学生成功", "系统消息", MessageBoxButtons.OK, MessageBoxIcon.Information);
                            //关闭当前窗体
                            this.Close();
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show("修改学生失败,具体原因：" + ex.Message, "系统消息", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                    break;
            }

        }

        private void btnChoosePhoto_Click(object sender, EventArgs e)
        {
            OpenFileDialog openFile = new OpenFileDialog();
            openFile.Filter = "图片文件|*.jpg;*.png";
            if (openFile.ShowDialog() == DialogResult.OK)
            {
                
                //获取选择文件的路径
                string photoPath = openFile.FileName;
                //展示再图片框中
                pbCurrentPhoto.BackgroundImage = Image.FromFile(photoPath);
                //另存到新文件夹

                //准备新文件的名称
                path = DateTime.Now.ToString("yyyyMMddHHmmss");
                Random objRandom = new Random();
                path += objRandom.Next(0, 99).ToString("00");
                path += photoPath.Substring(photoPath.Length - 4);
                path = ".\\image\\" + path;

                //另存为新路劲
                Bitmap objBitmap = new Bitmap(pbCurrentPhoto.BackgroundImage);
                objBitmap.Save(path, pbCurrentPhoto.BackgroundImage.RawFormat);
                objBitmap.Dispose();
            }
        }
    }
}


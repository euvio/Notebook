using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
using DAL;
using Models;


namespace StudentManage
{
    public partial class frmMain : Form
    {
        //定义DataTable存储学生信息
        DataTable dt = new DataTable();
        //实例化所有Student操作类
        StudentServices objStudentServices = new StudentServices();
        //定义一个实例窗体
        public static frmStudentDetail objFrmStudentDetail;
        //定义操作类型 
        int actionFlag = 0; //1--查看，2--添加，3--修改

        public frmMain()
        {
            InitializeComponent();

            //加载数据
            dt = objStudentServices.GetAllStudent();
            //加载到DataGridView中
            dgvStudent.DataSource = null;
            dgvStudent.AutoGenerateColumns = false;
            dgvStudent.DataSource = dt;

            //加载学生人数
            lblStudentNumber.Text = objStudentServices.GetStudentNumber().ToString();

        }

        private void btnQuery_Click(object sender, EventArgs e)
        {
            //调用
            dt.Clear();
            //准备性别
            string gender = string.Empty;
            if (cboQueryGender.Text.Contains("男")) gender = "男";
            else if (cboQueryGender.Text.Contains("女")) gender = "女";
            //接收查询后的结果
            dt = objStudentServices.GetStudent(txtQuerySNO.Text, txtQueryName.Text, gender, txtQueryMobile.Text);
            //绑定DataGridView 
            dgvStudent.DataSource = null;
            dgvStudent.DataSource = dt;
        }

        private void dgvStudent_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            //加载数据
            Student objStudent = objStudentServices.GetStudentBySNO(Convert.ToInt32(dgvStudent.CurrentRow.Cells[0].Value));

            //修改ActionFlag 
            actionFlag = 1;
            //加载到窗体
            if (objFrmStudentDetail == null)
            {
                objFrmStudentDetail = new frmStudentDetail(objStudent,actionFlag);
                objFrmStudentDetail.Show();
            }
            else
            {
                objFrmStudentDetail.Activate();
                objFrmStudentDetail.WindowState = FormWindowState.Normal;
            }
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            //修改ActionFlag 
            actionFlag = 2;
            //加载到窗体
            if (objFrmStudentDetail == null)
            {
                objFrmStudentDetail = new frmStudentDetail(null, actionFlag);
                DialogResult result = objFrmStudentDetail.ShowDialog();
                if (result == DialogResult.OK)
                {
                    dt.Clear();
                    dt = objStudentServices.GetAllStudent();
                    dgvStudent.DataSource = null;
                    dgvStudent.DataSource = dt;
                    //更新人数
                    lblStudentNumber.Text = objStudentServices.GetStudentNumber().ToString();
                }
            }
            else
            {
                objFrmStudentDetail.Activate();
                objFrmStudentDetail.WindowState = FormWindowState.Normal;
            }
        }

        private void btnUpdate_Click(object sender, EventArgs e)
        {

            //加载数据
            Student objStudent = objStudentServices.GetStudentBySNO(Convert.ToInt32(dgvStudent.CurrentRow.Cells[0].Value));

            //修改ActionFlag 
            actionFlag = 3;
            //加载到窗体
            if (objFrmStudentDetail == null)
            {
                objFrmStudentDetail = new frmStudentDetail(objStudent, actionFlag);
                DialogResult result= objFrmStudentDetail.ShowDialog();
                if (result == DialogResult.OK)
                {
                    //更新数据
                    dt.Clear();
                    dt = objStudentServices.GetAllStudent();
                    dgvStudent.DataSource = null;
                    dgvStudent.DataSource = dt;
                }
            }
            else
            {
                objFrmStudentDetail.Activate();
                objFrmStudentDetail.WindowState = FormWindowState.Normal;
            }
        }

        private void btnDelete_Click(object sender, EventArgs e)
        {
            string sno = dgvStudent.CurrentRow.Cells[0].Value.ToString();
            string info = "您确定要删除学生信息【 学号：" + sno + " 姓名：" + dgvStudent.CurrentRow.Cells[1].Value.ToString() + "】信息吗？";
            DialogResult result = MessageBox.Show(info,"系统消息",MessageBoxButtons.YesNo,MessageBoxIcon.Question);
            if (result == DialogResult.Yes)
            {
                try
                {
                    if (objStudentServices.DeleteStudent(Convert.ToInt32(sno)))
                    {
                        //刷洗表格 
                        dt.Clear();
                        dt = objStudentServices.GetAllStudent();
                        dgvStudent.DataSource = null;
                        dgvStudent.DataSource = dt;
                        //更新学生书 
                        lblStudentNumber.Text = objStudentServices.GetStudentNumber().ToString();
                        //显示删除成功
                        MessageBox.Show("删除成功!","系统消息", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("删除学生信息失败,具体原因：" + ex.Message, "系统消息", MessageBoxButtons.OK,MessageBoxIcon.Information);
                }
            }
            else return;
        }
    }
}

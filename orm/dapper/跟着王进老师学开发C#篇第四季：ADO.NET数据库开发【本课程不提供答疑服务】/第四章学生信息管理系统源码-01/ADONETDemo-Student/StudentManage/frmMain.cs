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
using Common;

namespace StudentManage
{
    public partial class FrmMain : Form
    {
        //用来存储学生信息的List
        private List<Student> objListStudent = new List<Student>();

        //用来处理Student信息的方法类
        private StudentServices objStudentServices = new StudentServices();

        //用来判断是添加操作还是修改操作
        private int actionFlag = 0;  //如果等于1，表示添加；如果等于2，表示修改

        //选择图片路径
        private string photoPath = string.Empty;

        //构造方法
        public FrmMain()
        {
            InitializeComponent();

            //窗体默认执行的操作

            //按钮控制
            EnableButton();

            //【1】把所有的学生信息存储在objlistStudent中
            dgvStudent.DataSource = null;
            dgvStudent.AutoGenerateColumns = false;

            //使用StudentServies类获取数据
            objListStudent = objStudentServices.GetAllStudent();
            //加载学生信息
            LoadStudent(objListStudent);

            //【3】显示所有学生数量
            lblTotal.Text = objStudentServices.GetStudentNumber().ToString();

        }

        //================控件事件=====================  
        private void dgvStudent_SelectionChanged(object sender, EventArgs e)
        {
            if (dgvStudent.Rows.Count == 0) return;
            else
            {
                try
                {
                    LoadStudentDetail(dgvStudent.CurrentRow.Cells[0].Value.ToString());
                }
                catch
                {
                    LoadStudentDetail(dgvStudent.Rows[0].Cells[0].Value.ToString());
                }
              
            }
        }

        private void txtQuerySNO_TextChanged(object sender, EventArgs e)
        {
            //获取查询结果
            objListStudent = objStudentServices.GetStudentBySNO(txtQuerySNO.Text.Trim());

            //更新DataGridview 
            LoadStudent(objListStudent);
        }

        private void txtQueryName_TextChanged(object sender, EventArgs e)
        {
            //获取查询结果
            objListStudent = objStudentServices.GetStudentBySName(txtQueryName.Text.Trim());

            //更新DataGridview 
            LoadStudent(objListStudent);
        }

        private void txtQueryMobile_TextChanged(object sender, EventArgs e)
        {
            //获取查询结果
            objListStudent = objStudentServices.GetStudentByMobile(txtQueryMobile.Text.Trim());

            //更新DataGridview 
            LoadStudent(objListStudent);
        }

        //为添加做准备
        private void btnAdd_Click(object sender, EventArgs e)
        {
            //控制按钮 
            DisableButton();

            //使输入框为空
            txtSNO.Text = string.Empty;
            txtName.Text = string.Empty;
            rbMale.Checked = true;
            txtMobile.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtHomeAddress.Text = string.Empty;

            //让学号获得焦点
            txtSNO.Focus();

            //控制Flag 
            actionFlag = 1;

        }

        private void btnUpdate_Click(object sender, EventArgs e)
        {
            //控制按钮 
            DisableButton();

            //学号信息不允许修改
            txtSNO.Enabled = false;

            //控制Flag 
            actionFlag = 2;
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            //按钮控制
            EnableButton();

            //默认加载
            
            if (actionFlag == 1)
            {
                objListStudent = objStudentServices.GetAllStudent();
                LoadStudent(objListStudent);
            }
        }

        private void btnCommit_Click(object sender, EventArgs e)
        {

            //有效性的校验 
            if (!CheckInput()) return;

            //封装Student 
            Student objStudent = new Student
            {
                SNO = Convert.ToInt32(txtSNO.Text.Trim()),
                SName = txtName.Text.Trim(),
                Birthday = Convert.ToDateTime(dtpBirthday.Text),
                Gender = rbMale.Checked == true ? "男" : "女",
                Mobile = txtMobile.Text.Trim(),
                Email = txtEmail.Text.Trim(),
                HomeAddress = txtHomeAddress.Text.Trim(),
                PhotoPath = null,
            };
            //处理照片
            if (pbCurrentPhoto.BackgroundImage != null)
            {
                objStudent.PhotoPath = PhotoSave(photoPath);
            }

            //执行提交
            switch (actionFlag)
            {
                case 1:   //添加的代码
                    try
                    {
                        //判断是否成功
                        if (objStudentServices.AddStudent(objStudent) == 1)
                        {
                            //刷新数据 
                            LoadStudent(objStudentServices.GetAllStudent());

                            //控制按钮
                            EnableButton();

                            //数量+1
                            lblTotal.Text = objStudentServices.GetStudentNumber().ToString();

                            //提示成功
                            MessageBox.Show("添加成功！" , "系统消息", MessageBoxButtons.OK, MessageBoxIcon.Information);
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show("添加学生信息出错,具体错误：" + ex.Message, "系统消息", MessageBoxButtons.OK,MessageBoxIcon.Information);
                    }
                    break;
                case 2:   //修改的代码
                    try
                    {
                        if (objStudentServices.UpdateSutdent(objStudent) == 1)
                        {
                            //刷新数据
                            LoadStudent(objStudentServices.GetAllStudent());

                            //控制按钮
                            EnableButton();

                            //启用学号 
                            txtSNO.Enabled = true;

                            //提示成功
                            MessageBox.Show("修改成功！", "系统消息", MessageBoxButtons.OK, MessageBoxIcon.Information);
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show("修改学生信息出错,具体错误：" + ex.Message, "系统消息", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                    break;
            }
        }

        private void btnDelete_Click(object sender, EventArgs e)
        {
            //必须要选择某一行记录
            if (dgvStudent.CurrentRow.Selected == false)
            {
                MessageBox.Show("删除前必须要选择某一行记录！","系统消息",MessageBoxButtons.OK,MessageBoxIcon.Information);
                return;
            }

            //准备删除前的提示
            string info = "您确定要删除学生信息【 学号：" + dgvStudent.CurrentRow.Cells[0].Value.ToString() + "  姓名：" +
                dgvStudent.CurrentRow.Cells[1].Value.ToString() + " 】吗？";

            DialogResult result = MessageBox.Show(info,"系统消息",MessageBoxButtons.YesNo,MessageBoxIcon.Question);

            //根据用户选择结果执行相应操作
            if (result == DialogResult.Yes)
            {
                //执行删除
                try
                {
                    if (objStudentServices.DeleteStudent(dgvStudent.CurrentRow.Cells[0].Value.ToString()) == 1)
                    {
                        //刷新数据 
                        LoadStudent(objStudentServices.GetAllStudent());

                        //数量-1
                        lblTotal.Text = objStudentServices.GetStudentNumber().ToString();

                        //提示成功
                        MessageBox.Show("删除成功！", "系统消息", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("删除出现错误,具体原因："+ex.Message,"系统消息",MessageBoxButtons.OK,MessageBoxIcon.Information);
                }

            }
            else return;
        }

        private void btnClose_Click(object sender, EventArgs e)
        {
            Close();
        }

        //为学生选择照片
        private void btnChoose_Click(object sender, EventArgs e)
        {
            //通过路径选择文件
            OpenFileDialog openFile = new OpenFileDialog();
            //设置文件筛选的类型
            openFile.Filter = "图片|*.bmp;*.jpg;*.png";
            //读取文件路径
            if (openFile.ShowDialog() == DialogResult.OK)
            {
                photoPath = openFile.FileName;
                pbCurrentPhoto.BackgroundImage = Image.FromFile(photoPath);
            }

        }


        //=================自定义事件========================
        private void LoadStudentDetail(string sno)
        {
            //实例化一个Student对象 
            Student objStudent = objStudentServices.GetCurrentStudent(sno);

            //展示明细
            txtSNO.Text = objStudent.SNO.ToString();
            txtName.Text = objStudent.SName;
            if (objStudent.Gender == "男") rbMale.Checked = true;
            else rbFemale.Checked = true;
            dtpBirthday.Text = objStudent.Birthday.ToString("yyyy-MM-dd");
            txtMobile.Text = objStudent.Mobile;
            txtEmail.Text = objStudent.Email;
            txtHomeAddress.Text = objStudent.HomeAddress;
            //照片：后面处理
            if (string.IsNullOrWhiteSpace(objStudent.PhotoPath))
            {
                pbCurrentPhoto.BackgroundImage = null;
            }
            else
            {
                pbCurrentPhoto.BackgroundImage = Image.FromFile(objStudent.PhotoPath);
            }
        }

        private void LoadStudent(List<Student> objList)
        {
            
            //判断是否有数据
            if (objList == null)
            {
                MessageBox.Show("学生表中没有任何数据！", "系统消息", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }
            else
            {
                dgvStudent.DataSource = null;
                dgvStudent.DataSource = objList;

                //展示第一个学生信息到明细中
                LoadStudentDetail(dgvStudent.Rows[0].Cells[0].Value.ToString());
               
            }
        }

        private void EnableButton()
        {
            //启用 
            btnAdd.Enabled = true;
            btnUpdate.Enabled = true;
            btnDelete.Enabled = true;

            //禁用明细区域
            gboxStudentDetail.Enabled = false;
        }

        private void DisableButton()
        {
            //启用 
            btnAdd.Enabled = false;
            btnUpdate.Enabled = false;
            btnDelete.Enabled = false;

            //禁用明细区域
            gboxStudentDetail.Enabled = true;
        }

        private bool CheckInput()
        {
            //判断学号为空
            if (string.IsNullOrWhiteSpace(txtSNO.Text))
            {
                MessageBox.Show("学号不能为空！","系统提示",MessageBoxButtons.OK,MessageBoxIcon.Information);
                return false;
            }
            //判断学号是否重复(只有添加的时候)
            if (actionFlag == 1)
            {
                if (objStudentServices.IsExistSNO(txtSNO.Text.Trim()))
                {

                    MessageBox.Show("学号已经存在！", "系统提示", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    return false;
                }
            }

            //判断学号是否是5位数字 
            if(!ValiDate.ValiDateSNO(txtSNO.Text))
            {
                MessageBox.Show("学号必须是95开头的5位数字！", "系统提示", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return false;
            }
            //判断姓名为空
            if (string.IsNullOrWhiteSpace(txtName.Text))
            {
                MessageBox.Show("姓名不能为空！", "系统提示", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return false;
            }


            //判断手机号码
            if (!ValiDate.ValiDateMobile(txtMobile.Text))
            {
                MessageBox.Show("手机号码必须是11位数字！", "系统提示", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return false;
            }

            //邮箱地址
            if (!ValiDate.ValiDateEmail(txtEmail.Text))
            {
                MessageBox.Show("邮箱地址不符合规范！", "系统提示", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return false;
            }

            return true;
        }

        private string PhotoSave(string currentPhotoPath)
        {
            //生成16位图片名称(14位时间和日期+ 2位随机值 + 后缀名)
            string PhotoName = DateTime.Now.ToString("yyyyMMddHHmmss");
            //加上两位随机值
            Random objRandom = new Random();
            PhotoName += objRandom.Next(0, 100).ToString("00");
            //加上文件后缀名
            PhotoName += currentPhotoPath.Substring(currentPhotoPath.Length - 4);
            //生成完整的相对路径
            PhotoName = ".\\image\\" + PhotoName;

            //把选择的图片另存到 新的相对路径
            Bitmap objBitmap = new Bitmap(pbCurrentPhoto.BackgroundImage);
            objBitmap.Save(PhotoName, pbCurrentPhoto.BackgroundImage.RawFormat);
            objBitmap.Dispose();

            //返回路径
            return PhotoName;
        }

        
    }
}



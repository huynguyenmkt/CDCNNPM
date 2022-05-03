using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace SignalR.Models
{
    public class Repository
    {
        SqlConnection con = new SqlConnection(System.Web.Configuration.WebConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
        public List<BangGiaTrucTuyen> GetAllMessages()
        {
            var messages = new List<BangGiaTrucTuyen>();
            con.Open();
            using (var cmd = new SqlCommand("SELECT [ID],[MaCP],[GiaMua3],[SoLuongMua3]" +
                ",[GiaMua2],[SoLuongMua2],[GiaMua1],[SoLuongMua1],[GiaBan1],[SoLuongBan1]," +
                "[GiaBan2],[SoLuongBan2],[GiaBan3],[SoLuongBan3],[GiaKhop],[SoLuongKhop]," +
                "[TongSo] FROM [dbo].[BangGiaTrucTuyen]", con))
            {
                cmd.Notification = null;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                var dependency = new SqlDependency(cmd);
                dependency.OnChange += new OnChangeEventHandler(dependency_OnChange);
                if (con.State != ConnectionState.Open)
                {
                    con.Open();
                }
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            messages.Add(item: new BangGiaTrucTuyen
                            {
                                ID = reader.GetInt32(0),
                                MaCP = reader.GetString(1),
                                GiaMua3 = reader.IsDBNull(2)? 0 : reader.GetDouble(2),
                                SoLuongMua3 = reader.IsDBNull(3) ? 0 : reader.GetInt32(3),
                                GiaMua2 = reader.IsDBNull(4) ? 0 : reader.GetDouble(4),
                                SoLuongMua2 = reader.IsDBNull(5) ? 0 : reader.GetInt32(5),
                                GiaMua1 = reader.IsDBNull(6) ? 0 : reader.GetDouble(6),
                                SoLuongMua1 = reader.IsDBNull(7) ? 0 : reader.GetInt32(7),
                                GiaBan1 = reader.IsDBNull(8) ? 0 : reader.GetDouble(8),
                                SoLuongBan1 = reader.IsDBNull(9) ? 0 : reader.GetInt32(9),
                                GiaBan2 = reader.IsDBNull(10) ? 0 : reader.GetDouble(10),
                                SoLuongBan2 = reader.IsDBNull(11) ? 0 : reader.GetInt32(11),
                                GiaBan3 = reader.IsDBNull(12) ? 0 : reader.GetDouble(12),
                                SoLuongBan3 = reader.IsDBNull(13) ? 0 : reader.GetInt32(13),
                                GiaKhop = reader.IsDBNull(14) ? 0 : reader.GetDouble(14),
                                SoLuongKhop = reader.IsDBNull(15) ? 0 : reader.GetInt32(15),
                                TongSo = reader.IsDBNull(16) ? 0 : reader.GetInt32(16)
                            });
                        }
                    }
                }
                
            }
            return messages;
        }

        private void dependency_OnChange(object sender, SqlNotificationEventArgs e) //this will be called when any changes occur in db table. 
        {
            if (e.Type == SqlNotificationType.Change)
            {
               
                MyHub.SendMessages();
            }
        }
    }
}
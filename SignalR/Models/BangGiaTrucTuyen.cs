using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SignalR.Models
{
    public class BangGiaTrucTuyen
    {
        public int ID { get; set; }
        public string MaCP { get; set; }
        public double? GiaMua3 { get; set; }
        public int? SoLuongMua3 { get; set; }
        public double? GiaMua2 { get; set; }
        public int? SoLuongMua2 { get; set; }
        public double? GiaMua1 { get; set; }
        public int? SoLuongMua1 { get; set; }
        public double? GiaBan1 { get; set; }
        public int? SoLuongBan1 { get; set; }
        public double? GiaBan2 { get; set; }
        public int? SoLuongBan2 { get; set; }
        public double? GiaBan3 { get; set; }
        public int? SoLuongBan3 { get; set; }
        public double? GiaKhop { get; set; }
        public int? SoLuongKhop { get; set; }
        public int? TongSo { get; set; }

    }
}
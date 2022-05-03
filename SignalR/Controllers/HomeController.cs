using SignalR.Models;
using System;
using System.Collections.Generic;
using System.Web.Mvc;
namespace SignalR.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";
            return View();
        }
        public JsonResult GetMessages()
        {
            List<BangGiaTrucTuyen> messages = new List<BangGiaTrucTuyen>();
            Repository r = new Repository();
            messages = r.GetAllMessages();
            return Json(messages, JsonRequestBehavior.AllowGet);
        }
    }
}
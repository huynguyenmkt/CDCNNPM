using System;
using System.Threading.Tasks;
using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(SignalR.Startup))]

namespace SignalR
{
    public class Startup
    {
            public void Configuration(IAppBuilder app)
            {
            //ConfigureAuth(app);
             app.MapSignalR();
            }
        }
    }

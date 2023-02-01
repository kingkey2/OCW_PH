using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Backend_CheckRepeatRegisterIP : System.Web.UI.Page {
    protected void Page_Load(object sender, EventArgs e) {

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static RepeatInfo CheckRepeatRegisterIP(string ASID, string LoginAccount) {
        RepeatInfo R = new RepeatInfo() { Result = enumResult.ERR };

        //if (CheckPermission(ASID)) {
            string SS;
            System.Data.SqlClient.SqlCommand DBCmd;
            System.Data.DataTable DT;
            System.Data.DataTable DT1;

            SS = " SELECT * FROM UserAccountTable WHERE LoginAccount = @LoginAccount ";
            DBCmd = new System.Data.SqlClient.SqlCommand();
            DBCmd.CommandText = SS;
            DBCmd.CommandType = System.Data.CommandType.Text;
            DBCmd.Parameters.Add("@LoginAccount", System.Data.SqlDbType.VarChar).Value = LoginAccount;
            DT = DBAccess.GetDB(EWinWeb.DBConnStr, DBCmd);

            if (DT != null && DT.Rows.Count > 0) {
                string RegisterIP = (string)DT.Rows[0]["RegisterIP"];
                R.IP = RegisterIP;

                SS = " SELECT * FROM UserAccountTable WHERE RegisterIP = @RegisterIP ";
                DBCmd = new System.Data.SqlClient.SqlCommand();
                DBCmd.CommandText = SS;
                DBCmd.CommandType = System.Data.CommandType.Text;
                DBCmd.Parameters.Add("@RegisterIP", System.Data.SqlDbType.VarChar).Value = RegisterIP;
                DT1 = DBAccess.GetDB(EWinWeb.DBConnStr, DBCmd);

                if (DT1 != null && DT1.Rows.Count > 0) {
                    foreach (System.Data.DataRow dr in DT1.Rows) {
                        R.LoginAccount += (string)dr["LoginAccount"] + " ; ";
                    }
                    
                    R.Result = enumResult.OK;
                } else {
                    R.Message = "註冊IP : " + RegisterIP + " 無重複註冊IP";
                }
            } else {
                R.Message = "查無帳號";
            }
        //} else {
        //    R.Message = "NoPermissions";
        //}
        return R;
    }

    private static bool CheckPermission(string ASID) {
        bool R = false;
        EWin.GlobalPermissionAPI.GlobalPermissionAPI GApi = new EWin.GlobalPermissionAPI.GlobalPermissionAPI();
        EWin.GlobalPermissionAPI.APIResult GR = new EWin.GlobalPermissionAPI.APIResult();

        GR = GApi.CheckPermission(ASID, EWinWeb.CompanyCode, "CheckRepeatRegisterIP", "CheckRepeatRegisterIP", "");

        if (GR.Result== EWin.GlobalPermissionAPI.enumResult.OK) {
            R = true;
        } 

        return R;
    }

    public static string GetToken() {
        string Token;
        int RValue;
        Random R = new Random();
        RValue = R.Next(100000, 9999999);
        Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());

        return Token;
    }

    private static void SetResultException(APIResult R, string Msg) {
        if (R != null) {
            R.Result = enumResult.ERR;
            R.Message = Msg;
        }
    }

    public class APIResult {
        public enumResult Result { get; set; }
        public string GUID { get; set; }
        public string Message { get; set; }
    }

    public enum enumResult {
        OK = 0,
        ERR = 1
    }

    public class RepeatInfo : APIResult {
        public string LoginAccount { get; set; }
        public string IP { get; set; }
    }
}
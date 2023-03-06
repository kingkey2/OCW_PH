using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Backend_CheckUserVipSchedule : System.Web.UI.Page {
    protected void Page_Load(object sender, EventArgs e) {

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static VIPInfo CheckUserVipSchedule(string ASID, string LoginAccount) {
        VIPInfo R = new VIPInfo() { Result = enumResult.ERR };

        if (CheckPermission(ASID)) {
            string SS;
            System.Data.SqlClient.SqlCommand DBCmd;
            System.Data.DataTable DT;

            SS = " SELECT * FROM UserAccountTable with (nolock) WHERE LoginAccount = @LoginAccount ";
            DBCmd = new System.Data.SqlClient.SqlCommand();
            DBCmd.CommandText = SS;
            DBCmd.CommandType = System.Data.CommandType.Text;
            DBCmd.Parameters.Add("@LoginAccount", System.Data.SqlDbType.VarChar).Value = LoginAccount;
            DT = DBAccess.GetDB(EWinWeb.DBConnStr, DBCmd);

            if (DT != null && DT.Rows.Count > 0) {
                string k = string.Empty;

                switch ((int)DT.Rows[0]["UserLevelIndex"]) {
                    case 0:
                        k = "VIP0";
                        break;
                    case 1:
                        k = "青銅";
                        break;
                    case 2:
                        k = "白銀";
                        break;
                    case 3:
                        k = "勇士";
                        break;
                    case 4:
                        k = "白金";
                        break;
                    case 5:
                        k = "鑽石";
                        break;
                    case 6:
                        k = "精英";
                        break;
                    case 7:
                        k = "金鑽";
                        break;
                    case 8:
                        k = "大師";
                        break;
                    case 9:
                        k = "宗師";
                        break;
                    case 10:
                        k = "史詩";
                        break;
                    default:
                        k = "VIP0";
                        break;
                }

                R.LoginAccount = LoginAccount;
                R.UserLevelIndex = k;
                R.UserLevelUpdateDate = ((DateTime)DT.Rows[0]["UserLevelUpdateDate"]).ToString("yyyy/MM/dd HH:mm:ss");
                R.UserLevelAccumulationDepositAmount = (decimal)DT.Rows[0]["UserLevelAccumulationDepositAmount"];
                R.UserLevelAccumulationValidBetValue = (decimal)DT.Rows[0]["UserLevelAccumulationValidBetValue"];

                R.Result = enumResult.OK;
            } else {
                R.Message = "查無帳號";
            }
        } else {
            R.Message = "NoPermissions";
        }
        return R;
    }

    private static bool CheckPermission(string ASID) {
        bool R = false;
        EWin.GlobalPermissionAPI.GlobalPermissionAPI GApi = new EWin.GlobalPermissionAPI.GlobalPermissionAPI();
        EWin.GlobalPermissionAPI.APIResult GR = new EWin.GlobalPermissionAPI.APIResult();

        GR = GApi.CheckPermission(ASID, EWinWeb.CompanyCode, "CheckUserVipSchedule", "CheckUserVipSchedule", "");

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

    public class VIPInfo : APIResult {
        public string LoginAccount { get; set; }
        public string UserLevelIndex { get; set; }
        public string UserLevelUpdateDate { get; set; }
        public decimal UserLevelAccumulationDepositAmount { get; set; }
        public decimal UserLevelAccumulationValidBetValue { get; set; }
    }
}
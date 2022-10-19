using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// CryptoExpand 的摘要描述
/// </summary>
public static class ActivityCore {
    public static string BasicFile = "/App_Data/Activity.json";


    public static ActResult<ActivityInfo> GetActInfo(string AcivityName) {
        ActResult<ActivityInfo> R = new ActResult<ActivityInfo>() { Result = enumActResult.OK, Data = new ActivityInfo() };
        JObject InProgressActivity;

        InProgressActivity = GetInProgressActivity();

        foreach (var item in InProgressActivity["Keep"]) {

            if (item["Name"].ToString().ToLower() == AcivityName.ToLower()) {
                ActivityInfo Info = new ActivityInfo();
                string DetailPath = null;
                DetailPath = InProgressActivity["BasicPath"] + item["Path"].ToString();
                JObject ActivityDetail = GetActivityDetail(DetailPath);

                Info.ActivityName = ActivityDetail["Name"].ToString();
                Info.Title = ActivityDetail["Title"].ToString();
                Info.SubTitle = ActivityDetail["SubTitle"].ToString();

                R.Data = Info;

                break;
            }
        }

        if (R.Data != null) {
            R.Result = enumActResult.OK;
            R.Message = "";
        } else {
            R.Result = enumActResult.ERR;
            R.Message = "NoData";

        }

        return R;
    }

    public static ActResult<List<ActivityInfo>> GetActInfos() {
        ActResult<List<ActivityInfo>> R = new ActResult<List<ActivityInfo>>() { Result = enumActResult.OK, Data = new List<ActivityInfo>() };
        JObject InProgressActivity;

        InProgressActivity = GetInProgressActivity();

        foreach (var item in InProgressActivity["Keep"]) {
            ActivityInfo Info = new ActivityInfo();
            string DetailPath = null;
            DetailPath = InProgressActivity["BasicPath"] + item["Path"].ToString();
            JObject ActivityDetail = GetActivityDetail(DetailPath);

            Info.ActivityName = ActivityDetail["Name"].ToString();
            Info.Title = ActivityDetail["Title"].ToString();
            Info.SubTitle = ActivityDetail["SubTitle"].ToString();

            R.Data.Add(Info);
        }

        R.Result = enumActResult.OK;
        R.Message = "";

        return R;
    }

    //儲值相關活動

    //暫時未使用到
    public static ActResult<List<ActJoinCheck>> GetDepositJoinCheck(decimal Amount, string PaymentCode, string LoginAccount) {
        ActResult<List<ActJoinCheck>> R = new ActResult<List<ActJoinCheck>>() {
            Data = new List<ActJoinCheck>()
        };
        JObject InProgressActivity;

        InProgressActivity = GetInProgressActivity();

        foreach (var item in InProgressActivity["Deposit"]) {
            ActResult<ActJoinCheck> InfoResult;
            string DetailPath = null;
            string MethodName = null;

            DetailPath = InProgressActivity["BasicPath"] + item["Path"].ToString();
            MethodName = item["InfoMethodName"].ToString();

            InfoResult = (ActResult<ActJoinCheck>)(typeof(ActivityExpand.DepositJoinCheck).GetMethod(MethodName).Invoke(null, new object[] { DetailPath, Amount, PaymentCode, LoginAccount }));

            if (InfoResult.Result == enumActResult.OK) {
                R.Data.Add(InfoResult.Data);
            }
        }

        R.Result = enumActResult.OK;
        R.Message = "";

        return R;
    }

    public static ActResult<DepositActivity> GetDepositResult(string ActiviyName, decimal Amount, string PaymentCode, string LoginAccount) {
        ActResult<DepositActivity> R = new ActResult<DepositActivity>() { Result = enumActResult.ERR };
        JObject InProgressActivity;


        bool IsInProgress = false;
        string DetailPath = null;
        string MethodName = null;

        InProgressActivity = GetInProgressActivity();

        foreach (var item in InProgressActivity["Deposit"]) {
            if (item["Name"].ToString().ToUpper() == ActiviyName.ToUpper()) {
                IsInProgress = true;
                DetailPath = InProgressActivity["BasicPath"] + item["Path"].ToString();
                MethodName = item["MethodName"].ToString();
                break;
            }
        }

        if (IsInProgress) {
            var DR = (ActResult<DepositActivity>)(typeof(ActivityExpand.Deposit).GetMethod(MethodName).Invoke(null, new object[] { DetailPath, Amount, PaymentCode, LoginAccount }));

            if (DR.Result == enumActResult.OK) {
                R.Result = enumActResult.OK;
                R.Data = DR.Data;
                R.Data.ActivityName = ActiviyName;
            } else {
                SetResultException(R, "GetActivityFailure,Msg=" + DR.Message);
            }
        } else {
            SetResultException(R, "ActivityIsExpired");
        }

        return R;
    }

    public static ActResult<List<DepositActivity>> GetDepositAllResult(decimal Amount, string PaymentCode, string LoginAccount) {
        ActResult<List<DepositActivity>> R = new ActResult<List<DepositActivity>>() {
            Data = new List<DepositActivity>()
        };
        JObject InProgressActivity;

        InProgressActivity = GetInProgressActivity();
        string DetailPath = null;
        string MethodName = null;

        foreach (var item in InProgressActivity["Deposit"]) {
            ActResult<ActivityCore.DepositActivity> DataReslut;
            DetailPath = InProgressActivity["BasicPath"] + item["Path"].ToString();
            MethodName = item["MethodName"].ToString();

            DataReslut = (ActResult<ActivityCore.DepositActivity>)(typeof(ActivityExpand.Deposit).GetMethod(MethodName).Invoke(null, new object[] { DetailPath, Amount, PaymentCode, LoginAccount }));

            if (DataReslut.Result == enumActResult.OK) {
                DataReslut.Data.ActivityName = item["Name"].ToString();
                R.Data.Add(DataReslut.Data);
            }
        }

        R.Result = enumActResult.OK;
        R.Message = "";

        return R;
    }

    public static ActResult<List<DepositActivity>> GetActivityAllResult() {
        ActResult<List<DepositActivity>> R = new ActResult<List<DepositActivity>>() {
            Data = new List<DepositActivity>()
        };
        JObject InProgressActivity;

        InProgressActivity = GetInProgressActivity();

        foreach (var item in InProgressActivity["All"]) {
            ActResult<ActivityCore.DepositActivity> DataReslut = new ActResult<DepositActivity>();
            DataReslut.Data = new DepositActivity();

            DataReslut.Data.ActivityName = item["Name"].ToString();
            DataReslut.Data.State = int.Parse(item["State"].ToString());
            DataReslut.Data.PageShowState = int.Parse(item["PageShowState"].ToString());
            
            R.Data.Add(DataReslut.Data);
        }

        R.Result = enumActResult.OK;
        R.Message = "";

        return R;
    }

    //上線獎勵(下線儲值完成，強制參加)
    //初期先LoginAccount(可能會有該LoginAccount貢獻等等)，高機率上下線資訊都需要，再以LoginAccount去撈取
    public static ActResult<List<IntroActivity>> GetAllParentBonusAfterDepositResult(string LoginAccount) {
        ActResult<List<IntroActivity>> R = new ActResult<List<IntroActivity>>() {
            Data = new List<IntroActivity>()
        };
        JObject InProgressActivity;

        InProgressActivity = GetInProgressActivity();
        string DetailPath = null;
        string MethodName = null;

        foreach (var item in InProgressActivity["ParentBonusAfterDeposit"]) {
            ActResult<IntroActivity> DataReslut;
            DetailPath = InProgressActivity["BasicPath"] + item["Path"].ToString();
            MethodName = item["MethodName"].ToString();

            DataReslut = (ActResult<IntroActivity>)(typeof(ActivityExpand.ParentBonusAfterDeposit).GetMethod(MethodName).Invoke(null, new object[] { DetailPath, LoginAccount }));


            if (DataReslut.Result == enumActResult.OK) {
                R.Data.Add(DataReslut.Data);
            }
        }

        R.Result = enumActResult.OK;
        R.Message = "";

        return R;
    }

    public static ActResult<List<Activity>> GetRegisterResult(string LoginAccount) {
        ActResult<List<Activity>> R = new ActResult<List<Activity>>() { Result = enumActResult.ERR, Data = new List<Activity>() };
        JObject InProgressActivity;

        string DetailPath = null;
        string MethodName = null;
        string ActiviyName = null;

        InProgressActivity = GetInProgressActivity();

        foreach (var item in InProgressActivity["Register"]) {
            DetailPath = InProgressActivity["BasicPath"] + item["Path"].ToString();
            MethodName = item["MethodName"].ToString();
            ActiviyName = item["Name"].ToString();

            var DR = (ActResult<Activity>)(typeof(ActivityExpand.Register).GetMethod(MethodName).Invoke(null, new object[] { DetailPath, LoginAccount }));

            if (DR.Result == enumActResult.OK) {

                R.Data.Add(DR.Data);
            }
        }


        R.Result = enumActResult.OK;
        R.Message = "";

        return R;
    }

    private static JObject GetInProgressActivity() {
        JObject o = null;
        string Filename;

        Filename = HttpContext.Current.Server.MapPath(BasicFile);

        if (System.IO.File.Exists(Filename)) {
            string SettingContent;

            SettingContent = System.IO.File.ReadAllText(Filename);

            if (string.IsNullOrEmpty(SettingContent) == false) {
                try { o = JObject.Parse(SettingContent); } catch (Exception ex) { }
            }
        }

        return o;
    }

    public static void SetResultException<T>(ActResult<T> R, string Msg) {
        if (R != null) {
            R.Result = enumActResult.ERR;
            R.Message = Msg;
        }
    }



    #region Model

    public class ActResult<T> {
        public enumActResult Result { get; set; }
        public string GUID { get; set; }
        public string Message { get; set; }
        public T Data { get; set; }
    }

    public enum enumActResult {
        OK = 0,
        ERR = 1
    }

    //活動基本文宣內容

    public class ActivityInfo {
        public string ActivityName { get; set; }
        public string Title { get; set; }
        public string SubTitle { get; set; }
    }

    public class ActJoinCheck : ActivityInfo {
        public bool IsCanJoin { get; set; }
        public string CanNotJoinDescription { get; set; }
    }


    //活動Class，含實際計算的各種屬性

    public class Activity {
        public string ActivityName { get; set; }
        public int State { get; set; }
        public int PageShowState { get; set; }
        public decimal BonusRate { get; set; }
        public decimal BonusValue { get; set; }
        public decimal ThresholdRate { get; set; }
        public decimal ThresholdValue { get; set; }
        public string Title { get; set; }
        public string SubTitle { get; set; }
        public string JoinActivityCycle { get; set; }
        public int JoinCount { get; set; }
        public string CollectType { get; set; }
    }


    public class DepositActivity : Activity {
        public string PaymentCode { get; set; }
        public decimal Amount { get; set; }
        public string CollectAreaType { get; set; }
    }

    public class IntroActivity : Activity {
        public string ParentLoginAccount { get; set; }
        public string LoginAccount { get; set; }
        public string CollectAreaType { get; set; }
    }
    #endregion

    private static JObject GetActivityDetail(string Path) {
        JObject o = null;
        string Filename;

        Filename = HttpContext.Current.Server.MapPath(Path);

        if (System.IO.File.Exists(Filename)) {
            string SettingContent;

            SettingContent = System.IO.File.ReadAllText(Filename);

            if (string.IsNullOrEmpty(SettingContent) == false) {
                try { o = JObject.Parse(SettingContent); } catch (Exception ex) { }
            }
        }

        return o;
    }
}
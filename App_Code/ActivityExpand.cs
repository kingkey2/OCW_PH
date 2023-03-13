using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


/// <summary>
/// CryptoExpand 的摘要描述
/// </summary>
public static class ActivityExpand {
    public static class Deposit {
        public static ActivityCore.ActResult<ActivityCore.DepositActivity> OpenIntroBonus(string DetailPath, decimal Amount, string PaymentCode, string LoginAccount) {
            ActivityCore.ActResult<ActivityCore.DepositActivity> R = new ActivityCore.ActResult<ActivityCore.DepositActivity> { Result = ActivityCore.enumActResult.ERR, Data = new ActivityCore.DepositActivity() };
            JObject ActivityDetail;
            System.Data.DataTable UserAccountTotalValueDT;
            int DepositCount = 0;

            ActivityDetail = GetActivityDetail(DetailPath);

            UserAccountTotalValueDT = RedisCache.UserAccountEventSummary.GetUserAccountEventSummaryByLoginAccount(LoginAccount);

            if (UserAccountTotalValueDT != null && UserAccountTotalValueDT.Rows.Count > 0) {
                for (int i = 0; i < UserAccountTotalValueDT.Rows.Count; i++) {

                    string ActivityName = (string)UserAccountTotalValueDT.Rows[i]["ActivityName"];

                    if (ActivityName == ActivityDetail["Name"].ToString()) {
                        DepositCount = (int)UserAccountTotalValueDT.Rows[i]["JoinCount"];
                    }
                }
            } else {
                DepositCount = 0;
            }

            if (ActivityDetail != null) {
                DateTime StartDate = DateTime.Parse(ActivityDetail["StartDate"].ToString());
                DateTime EndDate = DateTime.Parse(ActivityDetail["EndDate"].ToString());

                if ((int)ActivityDetail["State"] == 0) {
                    if (DateTime.Now >= StartDate && DateTime.Now < EndDate) {
                        if (DepositCount == 0) {
                            R.Data.Amount = Amount;
                            R.Data.PaymentCode = PaymentCode;
                            R.Data.BonusRate = 1;
                            R.Data.BonusValue = (decimal)ActivityDetail["Self"]["BonusValue"];
                            R.Data.ThresholdRate = 1;
                            R.Data.ThresholdValue = (decimal)ActivityDetail["Self"]["ThresholdValue"];
                            R.Data.Title = ActivityDetail["Title"].ToString();
                            R.Data.SubTitle = ActivityDetail["SubTitle"].ToString();
                            R.Data.CollectAreaType = ActivityDetail["CollectAreaType"].ToString();
                            R.Data.JoinCount = 1;

                            R.Result = ActivityCore.enumActResult.OK;
                        } else {
                            SetResultException(R, "ActivityIsExpired");
                        }
                    } else {
                        SetResultException(R, "ActivityIsExpired");
                    }
                } else {
                    SetResultException(R, "ActivityIsExpired");
                }
            } else {
                SetResultException(R, "ActivityIsExpired");
            }

            return R;
        }

        public static ActivityCore.ActResult<ActivityCore.DepositActivity> OpenBonusDeposit_UserNotFirstDeposit(string DetailPath, decimal Amount, string PaymentCode, string LoginAccount) {
            ActivityCore.ActResult<ActivityCore.DepositActivity> R = new ActivityCore.ActResult<ActivityCore.DepositActivity>() { Result = ActivityCore.enumActResult.ERR, Data = new ActivityCore.DepositActivity() };
            JObject ActivityDetail;
            System.Data.DataTable DT;
            System.Data.DataTable ProgressPaymentDT;
            int DepositCount = 0;
            bool CanJoinActivity = false;

            ActivityDetail = GetActivityDetail(DetailPath);

            DT = RedisCache.UserAccount.GetUserAccountByLoginAccount(LoginAccount);
            if (DT != null && DT.Rows.Count > 0) {
                DepositCount = (int)DT.Rows[0]["DepositCount"];
            }

            //若入金次數為0時還要確認該使用者是否有進行中的訂單，有進行中訂單時也等同首儲已使用
            if (DepositCount > 0) {
                CanJoinActivity = true;
            } else {
                ProgressPaymentDT = EWinWebDB.UserAccountPayment.GetInProgressPaymentByLoginAccount(LoginAccount, 0);

                if (ProgressPaymentDT != null && ProgressPaymentDT.Rows.Count > 0) {
                    CanJoinActivity = true;
                } else {
                    CanJoinActivity = false;
                }
            }

            if (CanJoinActivity) {
                if (ActivityDetail != null) {
                    DateTime StartDate = DateTime.Parse(ActivityDetail["StartDate"].ToString());
                    DateTime EndDate = DateTime.Parse(ActivityDetail["EndDate"].ToString());
                    bool IsPaymentCodeSupport = false;
                    decimal BonusRate = 0;
                    decimal ThresholdRate = 0;
                    decimal DepositMinValue = 0;
                    decimal ReceiveValueMaxLimit = 0;

                    if ((int)ActivityDetail["State"] == 0) {
                        if (DateTime.Now >= StartDate && DateTime.Now < EndDate) {
                            if (DepositCount == 1) {
                                foreach (var item in ActivityDetail["Rate1"]) {
                                    if (item["PaymentCode"].ToString().ToUpper() == PaymentCode.ToString().ToUpper()) {
                                        IsPaymentCodeSupport = true;
                                        BonusRate = (decimal)item["BonusRate"];
                                        ThresholdRate = (decimal)item["ThresholdRate"];
                                        DepositMinValue = (decimal)item["DepositMinValue"];
                                        ReceiveValueMaxLimit = (decimal)item["ReceiveValueMaxLimit"];

                                        break;
                                    }
                                }

                                if (Amount < DepositMinValue) {
                                    IsPaymentCodeSupport = false;
                                }

                                if (IsPaymentCodeSupport) {
                                    R.Result = ActivityCore.enumActResult.OK;
                                    R.Data.Amount = Amount;
                                    R.Data.PaymentCode = PaymentCode;
                                    R.Data.BonusRate = BonusRate;
                                    R.Data.BonusValue = Amount * BonusRate;

                                    //if (R.Data.BonusValue > ReceiveValueMaxLimit) {
                                    //    R.Data.BonusValue = ReceiveValueMaxLimit;
                                    //}

                                    R.Data.ThresholdRate = ThresholdRate;
                                    R.Data.ThresholdValue = R.Data.BonusValue * ThresholdRate;
                                    R.Data.Title = ActivityDetail["Title"].ToString();
                                    R.Data.SubTitle = ActivityDetail["SubTitle"].ToString();
                                    R.Data.CollectAreaType = ActivityDetail["CollectAreaType"].ToString();
                                    R.Data.JoinCount = 1;
                                } else {
                                    SetResultException(R, "PaymentCodeNotSupport");
                                }
                            } else if (DepositCount == 2) {
                                foreach (var item in ActivityDetail["Rate2"]) {
                                    if (item["PaymentCode"].ToString().ToUpper() == PaymentCode.ToString().ToUpper()) {
                                        IsPaymentCodeSupport = true;
                                        BonusRate = (decimal)item["BonusRate"];
                                        ThresholdRate = (decimal)item["ThresholdRate"];
                                        DepositMinValue = (decimal)item["DepositMinValue"];
                                        ReceiveValueMaxLimit = (decimal)item["ReceiveValueMaxLimit"];

                                        break;
                                    }
                                }

                                if (Amount < DepositMinValue) {
                                    IsPaymentCodeSupport = false;
                                }

                                if (IsPaymentCodeSupport) {
                                    R.Result = ActivityCore.enumActResult.OK;
                                    R.Data.Amount = Amount;
                                    R.Data.PaymentCode = PaymentCode;
                                    R.Data.BonusRate = BonusRate;
                                    R.Data.BonusValue = Amount * BonusRate;

                                    //if (R.Data.BonusValue > ReceiveValueMaxLimit) {
                                    //    R.Data.BonusValue = ReceiveValueMaxLimit;
                                    //}

                                    R.Data.ThresholdRate = ThresholdRate;
                                    R.Data.ThresholdValue = R.Data.BonusValue * ThresholdRate;
                                    R.Data.Title = ActivityDetail["Title"].ToString();
                                    R.Data.SubTitle = ActivityDetail["SubTitle"].ToString();
                                    R.Data.CollectAreaType = ActivityDetail["CollectAreaType"].ToString();
                                    R.Data.JoinCount = 2;
                                } else {
                                    SetResultException(R, "PaymentCodeNotSupport");
                                }
                            } else {
                                foreach (var item in ActivityDetail["Rate3"]) {
                                    if (item["PaymentCode"].ToString().ToUpper() == PaymentCode.ToString().ToUpper()) {
                                        IsPaymentCodeSupport = true;
                                        BonusRate = (decimal)item["BonusRate"];
                                        ThresholdRate = (decimal)item["ThresholdRate"];
                                        DepositMinValue = (decimal)item["DepositMinValue"];
                                        ReceiveValueMaxLimit = (decimal)item["ReceiveValueMaxLimit"];

                                        break;
                                    }
                                }

                                if (Amount < DepositMinValue) {
                                    IsPaymentCodeSupport = false;
                                }

                                if (IsPaymentCodeSupport) {
                                    R.Result = ActivityCore.enumActResult.OK;
                                    R.Data.Amount = Amount;
                                    R.Data.PaymentCode = PaymentCode;
                                    R.Data.BonusRate = BonusRate;
                                    R.Data.BonusValue = Amount * BonusRate;

                                    //if (R.Data.BonusValue > ReceiveValueMaxLimit) {
                                    //    R.Data.BonusValue = ReceiveValueMaxLimit;
                                    //}

                                    R.Data.ThresholdRate = ThresholdRate;
                                    R.Data.ThresholdValue = R.Data.BonusValue * ThresholdRate;
                                    R.Data.Title = ActivityDetail["Title"].ToString();
                                    R.Data.SubTitle = ActivityDetail["SubTitle"].ToString();
                                    R.Data.CollectAreaType = ActivityDetail["CollectAreaType"].ToString();
                                    R.Data.JoinCount = DepositCount;
                                } else {
                                    SetResultException(R, "PaymentCodeNotSupport");
                                }
                            }
                        } else {
                            SetResultException(R, "ActivityIsExpired");
                        }
                    } else {
                        SetResultException(R, "ActivityIsExpired");
                    }
                } else {
                    SetResultException(R, "ActivityIsExpired");
                }
            } else {
                SetResultException(R, "ActivityIsExpired");
            }

            return R;
        }

        public static ActivityCore.ActResult<ActivityCore.DepositActivity> FirstDepositBonus(string DetailPath, decimal Amount, string PaymentCode, string LoginAccount) {
            ActivityCore.ActResult<ActivityCore.DepositActivity> R = new ActivityCore.ActResult<ActivityCore.DepositActivity>() { Result = ActivityCore.enumActResult.ERR, Data = new ActivityCore.DepositActivity() };
            JObject ActivityDetail;
            System.Data.DataTable DT;
            System.Data.DataTable ProgressPaymentDT;
            int DepositCount = 0;
            bool CanJoinActivity = false;

            ActivityDetail = GetActivityDetail(DetailPath);

            DT = RedisCache.UserAccount.GetUserAccountByLoginAccount(LoginAccount);
            if (DT != null && DT.Rows.Count > 0) {
                DepositCount = (int)DT.Rows[0]["DepositCount"];
            }
            //若入金次數為0時還要確認該使用者是否有進行中的訂單，有進行中訂單時也不符合條件
            if (DepositCount == 0) {
                ProgressPaymentDT = EWinWebDB.UserAccountPayment.GetInProgressPaymentByLoginAccount(LoginAccount, 0);

                if (ProgressPaymentDT != null && ProgressPaymentDT.Rows.Count > 0) {
                    CanJoinActivity = false;
                } else {
                    CanJoinActivity = true;
                }
            } else {
                CanJoinActivity = false;
            }

            if (CanJoinActivity) {
                if (ActivityDetail != null) {
                    DateTime StartDate = DateTime.Parse(ActivityDetail["StartDate"].ToString());
                    DateTime EndDate = DateTime.Parse(ActivityDetail["EndDate"].ToString());
                    decimal BonusRate = 0;
                    decimal ThresholdRate = 0;
                    decimal DepositMinValue = 0;
                    decimal ReceiveValueMaxLimit = 0;

                    BonusRate = (decimal)ActivityDetail["BonusRate"];
                    ThresholdRate = (decimal)ActivityDetail["ThresholdRate"];
                    DepositMinValue = (decimal)ActivityDetail["DepositMinValue"];
                    ReceiveValueMaxLimit = (decimal)ActivityDetail["ReceiveValueMaxLimit"];

                    if ((int)ActivityDetail["State"] == 0) {
                        if (Amount >= DepositMinValue) {
                            if (DateTime.Now >= StartDate && DateTime.Now < EndDate) {

                                R.Result = ActivityCore.enumActResult.OK;
                                R.Data.Amount = Amount;
                                R.Data.PaymentCode = PaymentCode;
                                R.Data.BonusRate = BonusRate;
                                R.Data.BonusValue = Amount * BonusRate;

                                if (R.Data.BonusValue > ReceiveValueMaxLimit) {
                                    R.Data.BonusValue = ReceiveValueMaxLimit;
                                }

                                R.Data.ThresholdRate = ThresholdRate;
                                R.Data.ThresholdValue = R.Data.BonusValue * ThresholdRate;
                                R.Data.Title = ActivityDetail["Title"].ToString();
                                R.Data.SubTitle = ActivityDetail["SubTitle"].ToString();
                                R.Data.CollectAreaType = ActivityDetail["CollectAreaType"].ToString();
                                R.Data.JoinCount = 1;

                            } else {
                                SetResultException(R, "ActivityIsExpired");
                            }
                        } else {
                            SetResultException(R, "ActivityIsExpired");
                        }
                    } else {
                        SetResultException(R, "ActivityIsExpired");
                    }
                } else {
                    SetResultException(R, "ActivityIsExpired");
                }
            } else {
                SetResultException(R, "ActivityIsExpired");
            }

            return R;
        }
    }

    public static class DepositJoinCheck {
        //任何無法參加之原因皆要傳回
        public static ActivityCore.ActResult<ActivityCore.ActJoinCheck> OpenBonusDeposit(string DetailPath, decimal Amount, string PaymentCode, string LoginAccount) {
            ActivityCore.ActResult<ActivityCore.ActJoinCheck> R = new ActivityCore.ActResult<ActivityCore.ActJoinCheck>() { Data = new ActivityCore.ActJoinCheck() { IsCanJoin = false } };
            JObject ActivityDetail;
            System.Data.DataTable UserAccountTotalValueDT;
            int DepositCount = 0;

            ActivityDetail = GetActivityDetail(DetailPath);

            UserAccountTotalValueDT = RedisCache.UserAccountEventSummary.GetUserAccountEventSummaryByLoginAccount(LoginAccount);

            if (UserAccountTotalValueDT != null && UserAccountTotalValueDT.Rows.Count > 0) {
                for (int i = 0; i < UserAccountTotalValueDT.Rows.Count; i++) {

                    string ActivityName = (string)UserAccountTotalValueDT.Rows[i]["ActivityName"];

                    if (ActivityName == ActivityDetail["Name"].ToString()) {
                        DepositCount = (int)UserAccountTotalValueDT.Rows[i]["JoinCount"];
                    }
                }
            } else {
                DepositCount = 0;
            }

            if (ActivityDetail != null) {
                DateTime StartDate = DateTime.Parse(ActivityDetail["StartDate"].ToString());
                DateTime EndDate = DateTime.Parse(ActivityDetail["EndDate"].ToString());
                bool IsPaymentCodeSupport = false;

                if ((int)ActivityDetail["State"] == 0) {
                    if (DateTime.Now >= StartDate && DateTime.Now < EndDate) {
                        if (DepositCount == 0) {
                            foreach (var item in ActivityDetail["Rate1"]) {
                                if (item["PaymentCode"].ToString().ToUpper() == PaymentCode.ToString().ToUpper()) {
                                    IsPaymentCodeSupport = true;

                                    break;
                                }
                            }
                        } else if (DepositCount == 1) {
                            foreach (var item in ActivityDetail["Rate2"]) {
                                if (item["PaymentCode"].ToString().ToUpper() == PaymentCode.ToString().ToUpper()) {
                                    IsPaymentCodeSupport = true;

                                    break;
                                }
                            }
                        } else {
                            foreach (var item in ActivityDetail["Rate3"]) {
                                if (item["PaymentCode"].ToString().ToUpper() == PaymentCode.ToString().ToUpper()) {
                                    IsPaymentCodeSupport = true;

                                    break;
                                }
                            }
                        }

                        if (IsPaymentCodeSupport) {
                            R.Data.ActivityName = ActivityDetail["Name"].ToString();
                            R.Data.Title = ActivityDetail["Title"].ToString();
                            R.Data.SubTitle = ActivityDetail["SubTitle"].ToString();
                            R.Data.IsCanJoin = true;
                        } else {
                            R.Data.IsCanJoin = false;
                            R.Data.CanNotJoinDescription = "PaymentCodeNotSupport";
                        }
                    } else {
                        R.Data.IsCanJoin = false;
                        R.Data.CanNotJoinDescription = "ActivityIsExpired";
                    }
                } else {
                    R.Data.IsCanJoin = false;
                    R.Data.CanNotJoinDescription = "ActivityIsExpired";
                }
            } else {
                R.Data.IsCanJoin = false;
                R.Data.CanNotJoinDescription = "ActivityNotExist";
            }

            return R;
        }
    }

    public static class ParentBonusAfterDeposit {
        public static ActivityCore.ActResult<ActivityCore.IntroActivity> OpenIntroBonusToParent(string DetailPath, string LoginAccount, decimal Amount) {
            ActivityCore.ActResult<ActivityCore.IntroActivity> R = new ActivityCore.ActResult<ActivityCore.IntroActivity>() { Result = ActivityCore.enumActResult.ERR };
            EWin.OCW.OCW ocwAPI = new EWin.OCW.OCW();
            var ocwResult = ocwAPI.GetParentUserAccountInfo(EWinWeb.GetToken(), LoginAccount);

            if (ocwResult.ResultState == EWin.OCW.enumResultState.OK) {
                JObject ActivityDetail;
                System.Data.DataTable UserAccountTotalValueDT;
                int DepositCount = 0;

                ActivityDetail = GetActivityDetail(DetailPath);

                UserAccountTotalValueDT = RedisCache.UserAccountEventSummary.GetUserAccountEventSummaryByLoginAccount(LoginAccount);

                if (UserAccountTotalValueDT != null && UserAccountTotalValueDT.Rows.Count > 0) {
                    for (int i = 0; i < UserAccountTotalValueDT.Rows.Count; i++) {

                        string ActivityName = (string)UserAccountTotalValueDT.Rows[i]["ActivityName"];

                        if (ActivityName == ActivityDetail["Name"].ToString()) {
                            DepositCount = (int)UserAccountTotalValueDT.Rows[i]["JoinCount"];
                        }
                    }
                } else {
                    DepositCount = 0;
                }


                if (ActivityDetail != null) {
                    DateTime StartDate = DateTime.Parse(ActivityDetail["StartDate"].ToString());
                    DateTime EndDate = DateTime.Parse(ActivityDetail["EndDate"].ToString());


                    if ((int)ActivityDetail["State"] == 0) {
                        if (DepositCount == 0) {
                            if (DateTime.Now >= StartDate && DateTime.Now < EndDate) {
                                var RetData = new ActivityCore.IntroActivity() {
                                    BonusValue = (decimal)ActivityDetail["Parent"]["BonusValue"],
                                    ThresholdValue = (decimal)ActivityDetail["Parent"]["ThresholdValue"],
                                    LoginAccount = LoginAccount,
                                    ParentLoginAccount = ocwResult.ParentLoginAccount,
                                    ActivityName = ActivityDetail["Name"].ToString(),
                                    CollectAreaType = ActivityDetail["CollectAreaType"].ToString()
                                };

                                R.Data = RetData;
                                R.Result = ActivityCore.enumActResult.OK;
                            } else {
                                SetResultException(R, "ActivityIsExpired");
                            }
                        } else {
                            SetResultException(R, "ActivityIsExpired");
                        }
                    } else {
                        SetResultException(R, "ActivityIsExpired");
                    }
                } else {
                    SetResultException(R, "ActivityIsExpired");
                }
            } else {
                SetResultException(R, ocwResult.Message);
            }

            return R;
        }

        public static ActivityCore.ActResult<ActivityCore.IntroActivity> DepositBounsToParent(string DetailPath, string LoginAccount, decimal Amount) {
            ActivityCore.ActResult<ActivityCore.IntroActivity> R = new ActivityCore.ActResult<ActivityCore.IntroActivity>() { Result = ActivityCore.enumActResult.ERR };
            EWin.OCW.OCW ocwAPI = new EWin.OCW.OCW();

            if (Amount >= 100) {
                var ocwResult = ocwAPI.GetParentUserAccountInfo(EWinWeb.GetToken(), LoginAccount);

                if (ocwResult.ResultState == EWin.OCW.enumResultState.OK) {
                    JObject ActivityDetail;
                    System.Data.DataTable UserAccountTotalValueDT;
                    int DepositCount = 0;

                    ActivityDetail = GetActivityDetail(DetailPath);

                    UserAccountTotalValueDT = RedisCache.UserAccountEventSummary.GetUserAccountEventSummaryByLoginAccount(LoginAccount);

                    if (UserAccountTotalValueDT != null && UserAccountTotalValueDT.Rows.Count > 0) {
                        for (int i = 0; i < UserAccountTotalValueDT.Rows.Count; i++) {

                            string ActivityName = (string)UserAccountTotalValueDT.Rows[i]["ActivityName"];

                            if (ActivityName == ActivityDetail["Name"].ToString()) {
                                DepositCount = (int)UserAccountTotalValueDT.Rows[i]["JoinCount"];
                            }
                        }
                    } else {
                        DepositCount = 0;
                    }


                    if (ActivityDetail != null) {
                        DateTime StartDate = DateTime.Parse(ActivityDetail["StartDate"].ToString());
                        DateTime EndDate = DateTime.Parse(ActivityDetail["EndDate"].ToString());


                        if ((int)ActivityDetail["State"] == 0) {
                            if (DepositCount == 0) {
                                if (DateTime.Now >= StartDate && DateTime.Now < EndDate) {
                                    var RetData = new ActivityCore.IntroActivity() {
                                        BonusValue = (decimal)ActivityDetail["Parent"]["BonusValue"],
                                        ThresholdValue = (decimal)ActivityDetail["Parent"]["ThresholdValue"],
                                        LoginAccount = LoginAccount,
                                        ParentLoginAccount = ocwResult.ParentLoginAccount,
                                        ActivityName = ActivityDetail["Name"].ToString(),
                                        CollectAreaType = ActivityDetail["CollectAreaType"].ToString()
                                    };

                                    R.Data = RetData;
                                    R.Result = ActivityCore.enumActResult.OK;
                                } else {
                                    SetResultException(R, "ActivityIsExpired");
                                }
                            } else {
                                SetResultException(R, "ActivityIsExpired");
                            }
                        } else {
                            SetResultException(R, "ActivityIsExpired");
                        }
                    } else {
                        SetResultException(R, "ActivityIsExpired");
                    }
                } else {
                    SetResultException(R, ocwResult.Message);
                }
            } else {
                SetResultException(R, "ActivityIsExpired");
            }

            return R;
        }
    }

    public static class Register {
        //任何無法參加之原因皆要傳回
        public static ActivityCore.ActResult<ActivityCore.Activity> RegisterBouns(string DetailPath, string LoginAccount) {
            ActivityCore.ActResult<ActivityCore.Activity> R = new ActivityCore.ActResult<ActivityCore.Activity>() { Result = ActivityCore.enumActResult.ERR, Data = new ActivityCore.Activity() };
            JObject ActivityDetail;
            System.Data.DataTable DT;
            string ActivityName = string.Empty;
            bool ActivityIsAlreadyJoin = false;

            ActivityDetail = GetActivityDetail(DetailPath);

            if (ActivityDetail != null) {
                DateTime StartDate = DateTime.Parse(ActivityDetail["StartDate"].ToString());
                DateTime EndDate = DateTime.Parse(ActivityDetail["EndDate"].ToString());

                if ((int)ActivityDetail["State"] == 0) {
                    if (DateTime.Now >= StartDate && DateTime.Now < EndDate) {
                        ActivityName = (string)ActivityDetail["Name"];

                        DT = RedisCache.UserAccountEventSummary.GetUserAccountEventSummaryByLoginAccount(LoginAccount);

                        if (DT != null && DT.Rows.Count > 0) {
                            for (int i = 0; i < DT.Rows.Count; i++) {
                                if ((string)DT.Rows[i]["ActivityName"] == ActivityName) {
                                    ActivityIsAlreadyJoin = true;
                                }
                            }
                        }

                        if (ActivityIsAlreadyJoin) { 
                            SetResultException(R, "ActivityIsAlreadyJoin");
                        } else {
                            R.Data.ActivityName = ActivityDetail["Name"].ToString();
                            R.Data.Title = ActivityDetail["Title"].ToString();
                            R.Data.SubTitle = ActivityDetail["SubTitle"].ToString();
                            R.Data.BonusRate = 1;
                            R.Data.BonusValue = (decimal)ActivityDetail["Self"]["BonusValue"];
                            R.Data.ThresholdRate = 1;
                            R.Data.ThresholdValue = (decimal)ActivityDetail["Self"]["ThresholdValue"];
                            R.Data.CollectAreaType = ActivityDetail["CollectAreaType"].ToString();
                            R.Result = ActivityCore.enumActResult.OK;
                        }

                    } else {
                        SetResultException(R, "ActivityIsExpired");
                    }
                } else {
                    SetResultException(R, "ActivityIsExpired");
                }
            } else {
                SetResultException(R, "ActivityNotExist");
            }

            return R;
        }

        public static ActivityCore.ActResult<ActivityCore.Activity> RegisterBounsToParent(string DetailPath) {
            ActivityCore.ActResult<ActivityCore.Activity> R = new ActivityCore.ActResult<ActivityCore.Activity>() { Result = ActivityCore.enumActResult.ERR, Data = new ActivityCore.Activity() };
            JObject ActivityDetail;
            string ActivityName = string.Empty;

            ActivityDetail = GetActivityDetail(DetailPath);

            if (ActivityDetail != null) {
                DateTime StartDate = DateTime.Parse(ActivityDetail["StartDate"].ToString());
                DateTime EndDate = DateTime.Parse(ActivityDetail["EndDate"].ToString());

                if ((int)ActivityDetail["State"] == 0) {
                    if (DateTime.Now >= StartDate && DateTime.Now < EndDate) {
                        ActivityName = (string)ActivityDetail["Name"];

                        R.Data.ActivityName = ActivityDetail["Name"].ToString();
                        R.Data.Title = ActivityDetail["Title"].ToString();
                        R.Data.SubTitle = ActivityDetail["SubTitle"].ToString();
                        R.Data.BonusRate = 1;
                        R.Data.BonusValue = (decimal)ActivityDetail["Parent"]["BonusValue"];
                        R.Data.ThresholdRate = 1;
                        R.Data.ThresholdValue = (decimal)ActivityDetail["Parent"]["ThresholdValue"];
                        R.Data.CollectAreaType = ActivityDetail["CollectAreaType"].ToString();
                        R.Result = ActivityCore.enumActResult.OK;

                    } else {
                        SetResultException(R, "ActivityIsExpired");
                    }
                } else {
                    SetResultException(R, "ActivityIsExpired");
                }
            } else {
                SetResultException(R, "ActivityNotExist");
            }

            return R;
        }
    }

    public static class Basic {
        //任何無法參加之原因皆要傳回
        public static ActivityCore.ActResult<ActivityCore.ActivityInfo> GetActInfo(string DetailPath) {
            ActivityCore.ActResult<ActivityCore.ActivityInfo> R = new ActivityCore.ActResult<ActivityCore.ActivityInfo>() { Data = new ActivityCore.ActivityInfo() };
            JObject ActivityDetail;



            ActivityDetail = GetActivityDetail(DetailPath);

            R.Data.ActivityName = ActivityDetail["Name"].ToString();
            R.Data.Title = ActivityDetail["Title"].ToString();
            R.Data.SubTitle = ActivityDetail["SubTitle"].ToString();
            return R;
        }
    }

    public static class VIP {
        public static ActivityCore.ActResult<ActivityCore.ActivityInfo> GetActInfo(string DetailPath) {
            ActivityCore.ActResult<ActivityCore.ActivityInfo> R = new ActivityCore.ActResult<ActivityCore.ActivityInfo>() { Data = new ActivityCore.ActivityInfo() };
            JObject ActivityDetail;

            ActivityDetail = GetActivityDetail(DetailPath);

            R.Data.ActivityName = ActivityDetail["Name"].ToString();
            R.Data.Title = ActivityDetail["Title"].ToString();
            R.Data.SubTitle = ActivityDetail["SubTitle"].ToString();
            return R;
        }

        public static ActivityCore.ActResult<ActivityCore.Activity> UpgradeBonus(string DetailPath, string LoginAccount) {
            ActivityCore.ActResult<ActivityCore.Activity> R = new ActivityCore.ActResult<ActivityCore.Activity>() { Result = ActivityCore.enumActResult.ERR, Data = new ActivityCore.Activity() };
            JObject ActivityDetail;
            System.Data.DataTable DT;
            string ActivityName = string.Empty;
            bool ActivityIsAlreadyJoin = false;

            ActivityDetail = GetActivityDetail(DetailPath);

            if (ActivityDetail != null) {
                DateTime StartDate = DateTime.Parse(ActivityDetail["StartDate"].ToString());
                DateTime EndDate = DateTime.Parse(ActivityDetail["EndDate"].ToString());

                if ((int)ActivityDetail["State"] == 0) {
                    if (DateTime.Now >= StartDate && DateTime.Now < EndDate) {
                        ActivityName = (string)ActivityDetail["Name"];

                        DT = RedisCache.UserAccountEventSummary.GetUserAccountEventSummaryByLoginAccount(LoginAccount);

                        if (DT != null && DT.Rows.Count > 0) {
                            for (int i = 0; i < DT.Rows.Count; i++) {
                                if ((string)DT.Rows[i]["ActivityName"] == ActivityName) {
                                    ActivityIsAlreadyJoin = true;
                                }
                            }
                        }

                        if (ActivityIsAlreadyJoin) {
                            SetResultException(R, "ActivityIsAlreadyJoin");
                        } else {
                            R.Data.ActivityName = ActivityDetail["Name"].ToString();
                            R.Data.Title = ActivityDetail["Title"].ToString();
                            R.Data.SubTitle = ActivityDetail["SubTitle"].ToString();
                            R.Data.BonusRate = 1;
                            R.Data.BonusValue = (decimal)ActivityDetail["BonusValue"];
                            R.Data.ThresholdRate = 1;
                            R.Data.ThresholdValue = (decimal)ActivityDetail["ThresholdValue"];
                            R.Data.CollectAreaType = ActivityDetail["CollectAreaType"].ToString();
                            R.Result = ActivityCore.enumActResult.OK;
                        }

                    } else {
                        SetResultException(R, "ActivityIsExpired");
                    }
                } else {
                    SetResultException(R, "ActivityIsExpired");
                }
            } else {
                SetResultException(R, "ActivityNotExist");
            }

            return R;
        }
    }

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

    private static void SetResultException<T>(ActivityCore.ActResult<T> R, string Msg) {
        if (R != null) {
            R.Result = ActivityCore.enumActResult.ERR;
            R.Message = Msg;
        }
    }

    private static string GetToken() {
        string Token;
        int RValue;
        Random R = new Random();
        RValue = R.Next(100000, 9999999);
        Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());

        return Token;
    }
}
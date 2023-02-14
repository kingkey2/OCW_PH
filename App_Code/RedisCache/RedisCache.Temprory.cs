using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Runtime.Serialization;
using System.Web;

/// <summary>
/// RedisCache 的摘要描述
/// </summary>
public static partial class RedisCache
{
    public static class Temprory
    {
        private static string XMLPath = "Temporary";
        private static int DBIndex = 0;

        public static void SetCache(string Key, int TimeoutSecond, string Content)
        {
            string Key1;

            Key1 = XMLPath + ":" + Key;
            RedisWrite(DBIndex, Key1.ToUpper(), Content, TimeoutSecond);
        }

        public static string GetCache(string Key)
        {
            string Key1;
            string Content = null;

            Key1 = XMLPath + ":" + Key;
            if (KeyExists(DBIndex, Key1.ToUpper()))
                Content = RedisRead(DBIndex, Key1.ToUpper());

            return Content;
        }

        public static T CheckCacheOnce<T>(string Key, int TimeoutSecond, System.Func<T> func)
        {
            string Key1;
            T RetValue = default(T);

            Key1 = XMLPath + ":" + Key;
            if (KeyExists(DBIndex, Key1.ToUpper()))
            {
                string Content = RedisRead(DBIndex, Key1.ToUpper());

                if (typeof(T) == typeof(System.Data.DataTable))
                {
                    if (string.IsNullOrEmpty(Content) == false)
                    {
                        RetValue = (T)((object)DTDeserialize(Content));
                    }
                }
                else if (typeof(T) == typeof(System.Data.DataSet))
                {
                    if (string.IsNullOrEmpty(Content) == false)
                    {
                        RetValue = (T)((object)DSDeserialize(Content));
                    }
                }
                else
                {
                    if (string.IsNullOrEmpty(Content) == false)
                    {
                        RetValue = (T)CodingControl.XMLDeserial(Content, typeof(T));
                    }
                }
            }
            else
            {
                string Content;

                RetValue = func.Invoke();

                if (typeof(T) == typeof(System.Data.DataTable))
                {
                    Content = DTSerialize((System.Data.DataTable)((object)RetValue));
                }
                else if (typeof(T) == typeof(System.Data.DataSet))
                {
                    Content = DSSerialize((System.Data.DataSet)((object)RetValue));
                }
                else
                {
                    Content = CodingControl.XMLSerial(RetValue);
                }

                RedisWrite(DBIndex, Key1.ToUpper(), Content, TimeoutSecond);
            }

            return RetValue;
        }

        public static T CheckCacheOnceByJson<T>(string Key, int TimeoutSecond, System.Func<T> func)
        {
            string Key1;
            T RetValue = default(T); ;

            Key1 = XMLPath + ":" + Key;
            if (KeyExists(DBIndex, Key1.ToUpper()))
            {
                string Content = RedisRead(DBIndex, Key1.ToUpper());

                RetValue = Newtonsoft.Json.JsonConvert.DeserializeObject<T>(Content);
            }
            else
            {
                RetValue = func.Invoke();

                if (RetValue != null)
                {
                    string Content = Newtonsoft.Json.JsonConvert.SerializeObject(RetValue);

                    RedisWrite(DBIndex, Key1.ToUpper(), Content, TimeoutSecond);                  
                }            
            }

            return RetValue;
        }

        public static T CheckCache<T>(string Key, int TimeoutSecond, System.Func<T> func)
        {
            string Key1;
            T RetValue = default(T);

            Key1 = XMLPath + ":" + Key;
            if (KeyExists(DBIndex, Key1.ToUpper()))
            {
                string Content = RedisRead(DBIndex, Key1.ToUpper());

                if (typeof(T) == typeof(System.Data.DataTable))
                {
                    if (string.IsNullOrEmpty(Content) == false)
                    {
                        RetValue = (T)((object)DTDeserialize(Content));
                    }
                }
                else if (typeof(T) == typeof(System.Data.DataSet))
                {
                    if (string.IsNullOrEmpty(Content) == false)
                    {
                        RetValue = (T)((object)DSDeserialize(Content));
                    }
                }
                else
                {
                    if (string.IsNullOrEmpty(Content) == false)
                    {
                        RetValue = (T)CodingControl.XMLDeserial(Content, typeof(T));
                    }
                }

                RedisSetExpire(DBIndex, Key1.ToUpper(), TimeoutSecond);
            }
            else
            {
                string Content;

                RetValue = func.Invoke();

                if (typeof(T) == typeof(System.Data.DataTable))
                {
                    Content = DTSerialize((System.Data.DataTable)((object)RetValue));
                }
                else if (typeof(T) == typeof(System.Data.DataSet))
                {
                    Content = DSSerialize((System.Data.DataSet)((object)RetValue));
                }
                else
                {
                    Content = CodingControl.XMLSerial(RetValue);
                }

                RedisWrite(DBIndex, Key1.ToUpper(), Content, TimeoutSecond);
            }

            return RetValue;
        }

        public static void ResetCache(string Key)
        {
            string Key1;

            Key1 = XMLPath + ":" + Key;

            KeyDelete(DBIndex, Key1.ToUpper());
        }
    }
}
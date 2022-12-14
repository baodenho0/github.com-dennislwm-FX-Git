//|-----------------------------------------------------------------------------------------|
//|                                                           WallStreetForexRobot_v3.9.mq4 |
//|                                                            Copyright ? 2011, Dennis Lee |
//| Assert History                                                                          |
//| 1.32    Fixed bug in delete target lines, i.e. after trade line is deleted.             |
//| 1.31    Delete target lines after trade is closed (trade may be closed manually).       |
//| 1.30    Added Buy or Sell Stop/Limit user setting. Stop is conservative and Limit is    |
//|             aggressive.                                                                 |
//| 1.25    Updated with Swiss target profit lines.                                         |
//| 1.24    Once a trade has been opened, do not create trendline.                          |
//| 1.23    Updated with Swiss Parabolic SAR.                                               |
//| 1.22    Added ObjectDelete(). Tightened entry criteria for trendlines.                  |
//| 1.21    Fixed minor bug in Comment().                                                   |
//| 1.20    Added PlusSwiss.mqh.                                                            |
//|         Fixed Linex to use EasyLot.                                                     |
//| 1.10    Added PlusLinex.mqh.                                                            |
//|         Added PlusEasy.mqh.                                                             |
//| 1.00    Generated by EX4 TO MQ4 decompile Service.                                      |
//|-----------------------------------------------------------------------------------------|
#property copyright "Copyright ? 2011, Dennis Lee"
#property link      ""

#import "wininet.dll"
   int InternetOpenA(string a0, int a1, string a2, string a3, int a4);
   int InternetOpenUrlA(int a0, string a1, string a2, int a3, int a4, int a5);
   int InternetCloseHandle(int a0);
#import "WALLSTREET.dll"
   int SessionInit(int a0, int a1, int a2, int a3, string a4);
   int SessionDeinit(int a0, int a1, int a2, int a3, string a4);
//|-----------------------------------------------------------------------------------------|
//|                                    P A R A M V A L U E                                  |
//|   a0:   1  -EURUSD                                                                      |
//|         2  -GBPUSD                                                                      |
//|         3  -USDCHF                                                                      |
//|         4  -USDJPY                                                                      |
//|         5  -USDCAD                                                                      |
//|   a1:   1  -MaPeriod                                                                    |
//|         2  -NotUsed                                                                     |
//|         3  -NotUsed                                                                     |
//|         4  -NotUsed                                                                     |
//|         5  -NotUsed                                                                     |
//|         6  -NotUsed                                                                     |
//|         7  -Used by CloseOnProfit                                                       |
//|         8  -WprPeriod                                                                   |
//|         9  -NotUsed                                                                     |
//|         10 -Used by SecureProfit                                                        |
//|         11 -Used by SecureProfitTriger                                                  |
//|         12 -NotUsed                                                                     |
//|         13 -NotUsed                                                                     |
//|         14 -NotUsed                                                                     |
//|         15 -AtrLevel                                                                    |
//|         16 -AtrPeriod                                                                   |
//|         17 -Used by OpenLong and OpenShort                                              |
//|         18 -CciPeriod                                                                   |
//|         19 -Used by CheckLoss                                                           |
//|         20 -Hr used by CheckLoss                                                        |
//|         21 -StopLoss                                                                    |
//|         22 -TakeProfit                                                                  |
//|-----------------------------------------------------------------------------------------|
   int ParamValue(int a0, int a1);
   bool CheckCloseLong(int a0, double a1, double a2, double a3, double a4, double a5, double a6, double a7, double a8, double a9);
   bool CheckCloseShort(int a0, double a1, double a2, double a3, double a4, double a5, double a6, double a7, double a8, double a9);
   bool CheckOpenLong(int a0, double a1, double a2, double a3, double a4, double a5, double a6, double a7, double a8);
   bool CheckOpenShort(int a0, double a1, double a2, double a3, double a4, double a5, double a6, double a7, double a8);
#import

//---- Assert PlusEasy externs
extern string s1="-->PlusEasy Settings<--";
#include <pluseasy.mqh>
extern double EasyLot = 0.1;
//---- Assert PlusSwiss externs
extern string s2="-->PlusSwiss Settings<--";
#include <plusswiss.mqh>
//---- Assert PlusLinex externs
extern string s3="-->PlusLinex Settings<--";
#include <pluslinex.mqh>
extern string s3_1=" Set Buy/Sell Stop=0 or Limit=1.";
extern int LinexLimit=0;
extern int Magic = 4698523;
extern int AccountNo = 961648;
extern string EA_Comment = "";
extern int MaxSpread = 4;
extern int Slippage = 2;
int OrRetry = 3;
int gi_100 = 3;
extern bool StealthMode = FALSE;
bool gi_108 = TRUE;
extern bool CloseOnlyOnProfit = FALSE;
extern bool NFA = FALSE;
extern bool No_Hedge = FALSE;
extern string CS = "==== Custom Settings ====";
extern int StopLoss = 0;
extern int TakeProfit = 0;
extern int SecureProfit = 0;
extern int SecureProfitTriger = 0;
extern bool UseCustomPair = FALSE;
extern string UseSettingsFrom = "EURUSD";
extern string MM = "==== Risk Management ====";
extern bool RecoveryMode = FALSE;
extern double FixedLots = 0.1;
extern double AutoMM = 0.0;
extern double AutoMM_Max = 20.0;
extern int MaxAccountTrades = 3;
extern string FE = "==== Friday Exit Rules ====";
extern bool FridayExit = FALSE;
extern int LastTradeHour = 19;
extern int ExitHour = 20;
int gi_220 = 50;
double gd_224 = 25.0;
double gd_232 = 1.1;
int MaPeriod = 0;
int gi_244 = 0;
int gi_248 = 0;
int gi_252 = 0;
int gi_256 = 0;
int gi_260 = 0;
int gi_264 = 0;
int WprPeriod = 0;
int gi_272 = 0;
int gi_276 = 0;
int gi_280 = 0;
int gi_284 = 0;
int AtrLevel = 0;
int AtrPeriod = 0;
int gi_296 = 0;
int CciPeriod = 0;
int gi_304 = 0;
int Hr = 0;
int SymbolType = -1;
string gs_316 = "";
bool gi_324 = TRUE;
bool gi_328 = FALSE;
int g_stoplevel_332 = 0;
double g_minlot_336 = 0.01;
double g_maxlot_344 = 0.01;
double g_lotstep_352 = 0.01;
int g_lotsize_360 = 100000;
double g_marginrequired_364 = 1000.0;
double Pt = 0.0001;
double gd_unused_380 = 0.1;
double gd_unused_388 = 1.0;

int CheckWWW() {
   int li_20;
   bool li_ret_0 = TRUE;
   string ls_4 = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; Q312461)";
   bool li_12 = FALSE;
   int li_16 = InternetOpenA(ls_4, li_12, "0", "0", 0);
   if (li_16 != 0) {
      li_20 = InternetOpenUrlA(li_16, "http://www.wallstreet-forex.com", "0", 0, -2080374528, 0);
      if (li_20 == 0) li_ret_0 = FALSE;
      else InternetCloseHandle(li_20);
      InternetCloseHandle(li_16);
   } else li_ret_0 = FALSE;
   return (li_ret_0);
}

void init() {
   gi_324 = TRUE;
   SymbolType = -1;
   Comment("");
   if (ObjectFind("BKGR") >= 0) ObjectDelete("BKGR");
   if (ObjectFind("BKGR2") >= 0) ObjectDelete("BKGR2");
   if (ObjectFind("BKGR3") >= 0) ObjectDelete("BKGR3");
   if (ObjectFind("BKGR4") >= 0) ObjectDelete("BKGR4");
   if (ObjectFind("LV") >= 0) ObjectDelete("LV");
//--- Assert Added PlusLinex.mqh
   EasyInit();
   SwissInit(Linex1Magic,Linex2Magic);
   LinexInit();
}

int deinit() {
   Comment("");
   if (ObjectFind("BKGR") >= 0) ObjectDelete("BKGR");
   if (ObjectFind("BKGR2") >= 0) ObjectDelete("BKGR2");
   if (ObjectFind("BKGR3") >= 0) ObjectDelete("BKGR3");
   if (ObjectFind("BKGR4") >= 0) ObjectDelete("BKGR4");
   if (ObjectFind("LV") >= 0) ObjectDelete("LV");
   if (SymbolType != -1) SymbolType = MyDeinit();
   return (0);
}

int start() {
   double OrPrice;
   double ld_16;
   double ld_24;
   color color_32;
   double OrLot;
   int OrTicket;
   double price_156;
   double price_164;
   string ls_180;
   string Cmt = "";
   double ld_48 = 0;
   double ld_56 = 0;
   double ld_64 = 0;
   double ld_72 = 1;
   if (DayOfWeek() == 1 && iVolume(NULL, PERIOD_D1, 0) < 5.0) return (0);
   if (StringLen(Symbol()) < 6) return (0);
   if (gi_324) {
      Comment("\nInitializing ...");
      Sleep(100);
      RefreshRates();
      gi_324 = FALSE;
      g_stoplevel_332 = MarketInfo(Symbol(), MODE_STOPLEVEL);
      g_minlot_336 = MarketInfo(Symbol(), MODE_MINLOT);
      g_maxlot_344 = MarketInfo(Symbol(), MODE_MAXLOT);
      g_lotsize_360 = MarketInfo(Symbol(), MODE_LOTSIZE);
      g_lotstep_352 = MarketInfo(Symbol(), MODE_LOTSTEP);
      g_marginrequired_364 = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
      if (Digits <= 3) Pt = 0.01;
      else Pt = 0.0001;
      if (Digits == 3 || Digits == 5) gd_unused_380 = 0.1;
      else gd_unused_380 = 1;
      Sleep(1000);
      gi_328 = CheckWWW();
      Sleep(1000);
      if (!gi_328) gi_324 = TRUE;
   }
   if ((!IsTesting()) && IsStopped()) return (0);
   if ((!IsTesting()) && !IsTradeAllowed()) return (0);
   if ((!IsTesting()) && IsTradeContextBusy()) return (0);
   if (IsDllsAllowed() == FALSE) {
      Comment("\nWarning: Set Parameter **AllowDLL Imports** ON in menu Tools -> Options -> ExpertAdvisors.");
      Print("Warning: Set Parameter **AllowDLL Imports** ON in menu Tools -> Options -> ExpertAdvisors.");
      Alert("Warning: Set Parameter **AllowDLL Imports** ON in menu Tools -> Options -> ExpertAdvisors.");
      Sleep(30000);
      return (0);
   }
   if (SymbolType <= 0) {
      if (!gi_328) {
         Comment("\nInternet connection problem");
         Alert("Internet connection problem");
         Sleep(10000);
         return (0);
      }
      Comment("\nUpdating settings ...");
      //Sleep(2000);
      SymbolType = MyFirstInit();
      //Sleep(2000);
//--- Assert Added PlusLinex.mqh
      if (EasySL<=0) EasySL=StopLoss;
      if (EasyTP<=0) EasyTP=TakeProfit;      
      if (SymbolType < 0) Comment("\nInitializing ...");
   }
   if (SymbolType <= 0) {
      if (SymbolType == -8) {
         Comment("\nUnsupported currency pair " + gs_316 + ", Bid: " + DoubleToStr(Bid, Digits) + ", Ask: " + DoubleToStr(Ask, Digits));
         Alert("Unsupported currency pair " + gs_316 + ", Bid: " + DoubleToStr(Bid, Digits) + ", Ask: " + DoubleToStr(Ask, Digits));
      } else {
         Comment("\nInitialization is failed with error code " + DoubleToStr(SymbolType, 0));
         Alert("Initialization is failed with error code " + DoubleToStr(SymbolType, 0));
      }
      Sleep(10000);
      return (0);
   }
   if (MaPeriod <= 0 || WprPeriod <= 0 || AtrPeriod <= 0 || CciPeriod <= 0) {
      Comment("\nWrong initialization parameters for pair " + Symbol());
      Alert("Wrong initialization parameters for pair " + Symbol());
      Sleep(10000);
      return (0);
   }
   HideTestIndicators(TRUE);
   double M15_Close1 = iClose(NULL, PERIOD_M15, 1);
   double M15_Ma1 = iMA(NULL, PERIOD_M15, MaPeriod, 0, MODE_SMMA, PRICE_CLOSE, 1);
   double M15_Wpr1 = iWPR(NULL, PERIOD_M15, WprPeriod, 1);
   double M15_Atr1 = iATR(NULL, PERIOD_M15, AtrPeriod, 1);
   double M15_Cci1 = iCCI(NULL, PERIOD_M15, CciPeriod, PRICE_TYPICAL, 1);
   HideTestIndicators(FALSE);
   double ld_120 = 0;
   if (StringSubstr(AccountCurrency(), 0, 3) == "JPY") {
      ld_120 = MarketInfo("USDJPY" + StringSubstr(Symbol(), 6), MODE_BID);
      if (ld_120 > 0.1) ld_72 = ld_120;
      else ld_72 = 84;
   }
   if (StringSubstr(AccountCurrency(), 0, 3) == "GBP") {
      ld_120 = MarketInfo("GBPUSD" + StringSubstr(Symbol(), 6), MODE_BID);
      if (ld_120 > 0.1) ld_72 = 1 / ld_120;
      else ld_72 = 0.6211180124;
   }
   if (StringSubstr(AccountCurrency(), 0, 3) == "EUR") {
      ld_120 = MarketInfo("EURUSD" + StringSubstr(Symbol(), 6), MODE_BID);
      if (ld_120 > 0.1) ld_72 = 1 / ld_120;
      else ld_72 = 0.7042253521;
   }
   if (AutoMM > 0.0 && (!RecoveryMode)) OrLot = MathMax(g_minlot_336, MathMin(g_maxlot_344, MathCeil(MathMin(AutoMM_Max, AutoMM) / ld_72 / 100.0 * AccountFreeMargin() / g_lotstep_352 / (g_lotsize_360 / 100)) * g_lotstep_352));
   if (AutoMM > 0.0 && RecoveryMode) OrLot = CalcLots();
   if (AutoMM == 0.0) OrLot = FixedLots;
   Cmt = Cmt 
      + "\n  " 
      + "\n " 
      + "\n  Authorization - OK!" 
      + "\n -----------------------------------------------" 
      + "\n  SL = " + StopLoss + " pips / TP = " + TakeProfit + " pips" 
   + "\n  Spread = " + DoubleToStr((Ask - Bid) / Pt, 1) + " pips";
   if (Ask - Bid > MaxSpread * Pt) Cmt = Cmt + " - TOO HIGH";
   else Cmt = Cmt + " - NORMAL";
   Cmt = Cmt 
   + "\n -----------------------------------------------";
   if (AutoMM > 0.0) {
      Cmt = Cmt 
         + "\n  AutoMM - ENABLED" 
      + "\n  Risk = " + DoubleToStr(AutoMM, 1) + "%";
   }
   Cmt = Cmt 
   + "\n  Trading Lots = " + DoubleToStr(OrLot, 2);
   Cmt = Cmt 
   + "\n -----------------------------------------------";
   if (RecoveryMode) {
      Cmt = Cmt 
      + "\n  Recovery Mode - ENABLED";
   } else {
      Cmt = Cmt 
      + "\n  Recovery Mode - DISABLED";
   }
   if (StealthMode) {
      Cmt = Cmt 
      + "\n  Stealth Mode - ENABLED";
   } else {
      Cmt = Cmt 
      + "\n  Stealth Mode - DISABLED";
   }
   Cmt = Cmt 
   + "\n -----------------------------------------------";
   Comment(Cmt);
   if (ObjectFind("BKGR") < 0) {
      ObjectCreate("BKGR", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("BKGR", "g", 110, "Webdings", LightSlateGray);
      ObjectSet("BKGR", OBJPROP_CORNER, 0);
      ObjectSet("BKGR", OBJPROP_BACK, TRUE);
      ObjectSet("BKGR", OBJPROP_XDISTANCE, 5);
      ObjectSet("BKGR", OBJPROP_YDISTANCE, 15);
   }
   if (ObjectFind("BKGR2") < 0) {
      ObjectCreate("BKGR2", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("BKGR2", "g", 110, "Webdings", DimGray);
      ObjectSet("BKGR2", OBJPROP_BACK, TRUE);
      ObjectSet("BKGR2", OBJPROP_XDISTANCE, 5);
      ObjectSet("BKGR2", OBJPROP_YDISTANCE, 60);
   }
   if (ObjectFind("BKGR3") < 0) {
      ObjectCreate("BKGR3", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("BKGR3", "g", 110, "Webdings", DimGray);
      ObjectSet("BKGR3", OBJPROP_CORNER, 0);
      ObjectSet("BKGR3", OBJPROP_BACK, TRUE);
      ObjectSet("BKGR3", OBJPROP_XDISTANCE, 5);
      ObjectSet("BKGR3", OBJPROP_YDISTANCE, 45);
   }
   if (ObjectFind("LV") < 0) {
      ObjectCreate("LV", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("LV", "WALL STREET ROBOT", 9, "Tahoma Bold", White);
      ObjectSet("LV", OBJPROP_CORNER, 0);
      ObjectSet("LV", OBJPROP_BACK, FALSE);
      ObjectSet("LV", OBJPROP_XDISTANCE, 13);
      ObjectSet("LV", OBJPROP_YDISTANCE, 23);
   }
   if (ObjectFind("BKGR4") < 0) {
      ObjectCreate("BKGR4", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("BKGR4", "g", 110, "Webdings", DimGray);
      ObjectSet("BKGR4", OBJPROP_CORNER, 0);
      ObjectSet("BKGR4", OBJPROP_BACK, TRUE);
      ObjectSet("BKGR4", OBJPROP_XDISTANCE, 5);
      ObjectSet("BKGR4", OBJPROP_YDISTANCE, 84);
   }
   if (TakeProfit < g_stoplevel_332 * Point / Pt) TakeProfit = g_stoplevel_332 * Point / Pt;
   if (StopLoss < g_stoplevel_332 * Point / Pt) StopLoss = g_stoplevel_332 * Point / Pt;
   Slippage = Slippage * Pt;
   int CountMyOpenedBuys = 0;
   int CountMyOpenedSells = 0;
   int CountOtherOpenedBuys = 0;
   int CountOtherOpenedSells = 0;
   if (CloseOnlyOnProfit) gi_264 = FALSE;
   for (int pos_152 = OrdersTotal() - 1; pos_152 >= 0; pos_152--) {
      if (!OrderSelect(pos_152, SELECT_BY_POS, MODE_TRADES)) Print("Error in OrderSelect! Position:", pos_152);
      else {
         if (OrderType() <= OP_SELL && OrderSymbol() == Symbol()) {
            if (OrderMagicNumber() != Magic) {
               if (OrderType() == OP_BUY) CountOtherOpenedBuys++;
               else CountOtherOpenedSells++;
            }
            if (OrderMagicNumber() == Magic) {
               ld_64 += OrderProfit();
               if (OrderType() == OP_BUY) ld_48 = (Bid - OrderOpenPrice()) / Pt;
               else ld_48 = (OrderOpenPrice() - Ask) / Pt;
               ld_56 += ld_48;
               if (OrderType() == OP_BUY) {
                  CountMyOpenedBuys++;
                  if (OrderStopLoss() == 0.0 && StealthMode == FALSE) {
                     price_156 = NormalizeDouble(OrderOpenPrice() - StopLoss * Pt, Digits);
                     price_164 = NormalizeDouble(OrderOpenPrice() + TakeProfit * Pt, Digits);
                     OrderModify(OrderTicket(), OrderOpenPrice(), price_156, price_164, 0, Green);
                     continue;
                  }
                  if (Bid >= OrderOpenPrice() + TakeProfit * Pt || Bid <= OrderOpenPrice() - StopLoss * Pt || (CloseLong(OrderOpenPrice(), M15_Wpr1, M15_Close1, iOpen(NULL, PERIOD_M1,
                     1), iClose(NULL, PERIOD_M1, 1)) && TimeCurrent() - OrderOpenTime() > 180) || (FridayExit && DayOfWeek() == 5 && Hour() >= ExitHour && TimeCurrent() - OrderOpenTime() > 180)) {
                     for (int li_148 = 1; li_148 <= MathMax(1, OrRetry); li_148++) {
                        RefreshRates();
                        if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), Slippage, Violet)) {
                           CountMyOpenedBuys--;
                           break;
                        }
                        Sleep(MathMax(100, 1000 * gi_100));
                     }
                     Sleep(5000);
                     continue;
                  }
                  if (!(Bid - OrderOpenPrice() > SecureProfitTriger * Pt && MathAbs(OrderOpenPrice() + SecureProfit * Pt - OrderStopLoss()) >= Point)) continue;
                  OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() + SecureProfit * Pt, Digits), OrderTakeProfit(), 0, Blue);
                  continue;
               }
               CountMyOpenedSells++;
               if (OrderStopLoss() == 0.0 && StealthMode == FALSE) {
                  price_156 = NormalizeDouble(OrderOpenPrice() + StopLoss * Pt, Digits);
                  price_164 = NormalizeDouble(OrderOpenPrice() - TakeProfit * Pt, Digits);
                  OrderModify(OrderTicket(), OrderOpenPrice(), price_156, price_164, 0, Green);
                  continue;
               }
               if (Ask <= OrderOpenPrice() - TakeProfit * Pt || Ask >= OrderOpenPrice() + StopLoss * Pt || (CloseShort(OrderOpenPrice(), M15_Wpr1, M15_Close1, iOpen(NULL,
                  PERIOD_M1, 1), iClose(NULL, PERIOD_M1, 1)) && TimeCurrent() - OrderOpenTime() > 180) || (FridayExit && DayOfWeek() == 5 && Hour() >= ExitHour && TimeCurrent() - OrderOpenTime() > 180)) {
                  for (li_148 = 1; li_148 <= MathMax(1, OrRetry); li_148++) {
                     RefreshRates();
                     if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), Slippage, Violet)) {
                        CountMyOpenedSells--;
                        break;
                     }
                     Sleep(MathMax(100, 1000 * gi_100));
                  }
                  Sleep(5000);
                  continue;
               }
               if (OrderOpenPrice() - Ask > SecureProfitTriger * Pt && MathAbs(OrderOpenPrice() - SecureProfit * Pt - OrderStopLoss()) >= Point) OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() - SecureProfit * Pt, Digits), OrderTakeProfit(), 0, Red);
            }
         }
      }
   }
   Cmt = Cmt 
   + "\n  Account Ballance = " + DoubleToStr(AccountBalance(), 2);
   if (CountMyOpenedBuys == 0 && CountMyOpenedSells == 0) {
      Cmt = Cmt 
         + "\n  No active trades" 
      + "\n";
   } else {
      Cmt = Cmt 
         + "\n  Current trade " + DoubleToStr(ld_56, 1) 
      + "\n  Account Profit = " + DoubleToStr(ld_64, 2);
   }
//--- Assert Added PlusLinex.mqh
   Cmt=StringConcatenate(Cmt,"\n\n\n");
   double profit=EasyProfitsMagic(Linex1Magic)+EasyProfitsMagic(Linex2Magic);
   Cmt=EasyComment(profit,Cmt);
   Cmt=StringConcatenate(Cmt,"    Lot=",DoubleToStr(EasyLot,2),"\n");
   Cmt=SwissComment(Cmt);
   Cmt=LinexComment(Cmt);
   Comment(Cmt);

//--- Assert PlusSwiss.mqh
   if (EasyOrdersMagic(Linex1Magic)>0)
   {
      SwissManager(Linex1Magic,Symbol(),Pts);
   }
   else 
      if (ObjectFind(Linex1)<0 && ObjectFind(SwissTarget1)>=0) ObjectDelete(SwissTarget1);
   if (EasyOrdersMagic(Linex2Magic)>0)
   {
      SwissManager(Linex2Magic,Symbol(),Pts);
   }
   else
      if (ObjectFind(Linex2)<0 && ObjectFind(SwissTarget2)>=0) ObjectDelete(SwissTarget2);
   
   SwissTargetLinex(Pts);

//--- Assert Added PlusLinex.mqh
   int entryPipLimit,entryTP;
   string strtmp;
   int ticket;
   int wave=Linex(Pts);
   switch(wave)
   {
      case 1:  
         ticket=EasySell(Linex1Magic,EasyLot);
         if(ticket>0) 
         {
            if (ObjectFind(Linex1)>=0) ObjectDelete(Linex1);
            strtmp = "EasySell: "+Linex1+" "+Linex1Magic+" "+Symbol()+" "+ticket+" sell at " + DoubleToStr(Close[0],Digits);   
         }
         break;
      case -1: 
         ticket=EasyBuy(Linex1Magic,EasyLot); 
         if(ticket>0) 
         {
            if (ObjectFind(Linex1)>=0) ObjectDelete(Linex1);
            strtmp = "EasyBuy: "+Linex1+" "+Linex1Magic+" "+Symbol()+" "+ticket+" buy at " + DoubleToStr(Close[0],Digits);   
         }
         break;
      case 2:  
         ticket=EasySell(Linex2Magic,EasyLot);
         if(ticket>0) 
         {
            if (ObjectFind(Linex2)>=0) ObjectDelete(Linex2);
            strtmp = "EasySell: "+Linex2+" "+Linex2Magic+" "+Symbol()+" "+ticket+" sell at " + DoubleToStr(Close[0],Digits);   
         }
         break;
      case -2:  
         ticket=EasyBuy(Linex2Magic,EasyLot);
         if(ticket>0) 
         {
            if (ObjectFind(Linex2)>=0) ObjectDelete(Linex2);
            strtmp = "EasyBuy: "+Linex2+" "+Linex2Magic+" "+Symbol()+" "+ticket+" buy at " + DoubleToStr(Close[0],Digits);   
         }
         break;
   }
   if (wave!=0) Print(strtmp);


   bool li_172 = TRUE;
   bool li_176 = TRUE;
   if (NFA == TRUE && CountMyOpenedSells > 0 || CountMyOpenedBuys > 0) {
      li_172 = FALSE;
      li_176 = FALSE;
   }
   if (NFA == TRUE && CountOtherOpenedSells > 0 || CountOtherOpenedBuys > 0) {
      li_172 = FALSE;
      li_176 = FALSE;
   }
   if (No_Hedge == TRUE && CountMyOpenedSells > 0 || CountOtherOpenedSells > 0) li_172 = FALSE;
   if (No_Hedge == TRUE && CountMyOpenedBuys > 0 || CountOtherOpenedBuys > 0) li_176 = FALSE;
   if (!gi_108) gi_296 = 1000;
   else gi_296 = gi_296;
   if (M15_Atr1 <= AtrLevel * Pt) return (0);
   if (OrdersTotal() >= MaxAccountTrades) return (0);
   if (FridayExit && DayOfWeek() == 5 && Hour() > LastTradeHour) return (0);
   int OrType = -1;
   if (CountMyOpenedBuys < 1 && OpenLong(M15_Close1, M15_Ma1, M15_Wpr1, M15_Cci1)) {
      if (Ask - Bid > MaxSpread * Pt) {
         Print("BUY not taken!!! - High spread...");
         Sleep(1000);
      } else {
         if (!li_172) {
            Print("BUY not taken!!! - No Hedge, or FIFO restriction ...");
            Sleep(1000);
         } else {
            ls_180 = "BUY";
            OrType = 0;
            color_32 = Aqua;
            RefreshRates();
            OrPrice = NormalizeDouble(Ask, Digits);
            ld_16 = OrPrice - StopLoss * Pt;
            ld_24 = OrPrice + TakeProfit * Pt;
         }
      }
   }
   if (CountMyOpenedSells < 1 && OpenShort(M15_Close1, M15_Ma1, M15_Wpr1, M15_Cci1)) {
      if (Ask - Bid > MaxSpread * Pt) {
         Print("SELL not taken!!! - High spread...");
         Sleep(1000);
      } else {
         if (!li_176) {
            Print("SELL not taken!!! - No Hedge, or FIFO restriction ...");
            Sleep(1000);
         } else {
            ls_180 = "SELL";
            OrType = 1;
            color_32 = Red;
            RefreshRates();
            OrPrice = NormalizeDouble(Bid, Digits);
            ld_16 = OrPrice + StopLoss * Pt;
            ld_24 = OrPrice - TakeProfit * Pt;
         }
      }
   }
   
   if (OrType >= OP_BUY && CheckLossPause()) {
      RefreshRates();
   //--- Switch Ask and Bid for trendlines.
      string desc="";
   //--- Added Buy or Sell Stop/Limit user setting.
      int countLosingTrades=EasyCountLosingTradesMagic(Magic,3);
      if (countLosingTrades>3) countLosingTrades=3;
      
      entryPipLimit=LinexPipLimit+countLosingTrades;
      entryTP=TakeProfit-entryPipLimit;
      
      if (OrType==OP_SELL) 
         OrPrice=NormalizeDouble(CalcEntryPrice(OP_SELL, LinexLimit, Bid, entryPipLimit*Pts),Digits);
      else if (OrType==OP_BUY) 
         OrPrice=NormalizeDouble(CalcEntryPrice(OP_BUY, LinexLimit, Ask, entryPipLimit*Pts),Digits);

   //--- Assert Added PlusLinex.mqh.
      if (OrType==OP_BUY)
      {
            if (EasyOrdersMagic(Linex2Magic)<=0) 
            {
                desc="BUY: Lot="+DoubleToStr(EasyLot,2)+" Entry="+DoubleToStr(OrPrice,5)+
                   " Ask="+DoubleToStr(Ask,5)+" PipLimit="+DoubleToStr(entryPipLimit,0);
                TrendLinexCreate(Linex2,OrPrice,desc);    // account for market spread
                
                desc=SwissTarget2+": Price="+DoubleToStr(OrPrice+(entryTP*Pts),5)+" TP="+DoubleToStr(entryTP,0);
                TrendLinexCreate(SwissTarget2,OrPrice+(entryTP*Pts),desc);
            }
      }
      else if (OrType==OP_SELL)
      {
            if (EasyOrdersMagic(Linex1Magic)<=0) 
            {
                desc="SELL: Lot="+DoubleToStr(EasyLot,2)+" Entry="+DoubleToStr(OrPrice,5)+
                   " Bid="+DoubleToStr(Bid,5)+" PipLimit="+DoubleToStr(entryPipLimit,0);
                TrendLinexCreate(Linex1,OrPrice,desc);    // account for market spread

                desc=SwissTarget1+": Price="+DoubleToStr(OrPrice-(entryTP*Pts),5)+" TP="+DoubleToStr(entryTP,0);
                TrendLinexCreate(SwissTarget1,OrPrice-(entryTP*Pts),desc);
            }
      }
   }
   return (0);
}

double CalcLots() {
   double ld_16;
   int count_24;
   double ld_28;
   int li_36;
   double ld_40;
   int li_48;
   double ld_52;
   int li_60;
   double ld_8 = 1;
   if (gd_232 > 0.0 && AutoMM > 0.0) {
      ld_16 = 0;
      count_24 = 0;
      ld_28 = 0;
      li_36 = 0;
      ld_40 = 0;
      li_48 = 0;
      for (int pos_64 = OrdersHistoryTotal() - 1; pos_64 >= 0; pos_64--) {
         if (OrderSelect(pos_64, SELECT_BY_POS, MODE_HISTORY)) {
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic) {
               count_24++;
               ld_16 += OrderProfit();
               if (ld_16 > ld_40) {
                  ld_40 = ld_16;
                  li_48 = count_24;
               }
               if (ld_16 < ld_28) {
                  ld_28 = ld_16;
                  li_36 = count_24;
               }
               if (count_24 >= gi_220) break;
            }
         }
      }
      if (li_48 <= li_36) ld_8 = MathPow(gd_232, li_36);
      else {
         ld_16 = ld_40;
         count_24 = li_48;
         ld_52 = ld_40;
         li_60 = li_48;
         for (pos_64 = OrdersHistoryTotal() - li_48 - 1; pos_64 >= 0; pos_64--) {
            if (OrderSelect(pos_64, SELECT_BY_POS, MODE_HISTORY)) {
               if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic) {
                  if (count_24 >= gi_220) break;
                  count_24++;
                  ld_16 += OrderProfit();
                  if (ld_16 < ld_52) {
                     ld_52 = ld_16;
                     li_60 = count_24;
                  }
               }
            }
         }
         if (li_60 == li_48 || ld_52 == ld_40) ld_8 = MathPow(gd_232, li_36);
         else {
            if (MathAbs(ld_28 - ld_40) / MathAbs(ld_52 - ld_40) >= (gd_224 + 100.0) / 100.0) ld_8 = MathPow(gd_232, li_36);
            else ld_8 = MathPow(gd_232, li_60);
         }
      }
   }
   for (double ld_ret_0 = MathMax(g_minlot_336, MathMin(g_maxlot_344, MathCeil(MathMin(AutoMM_Max, ld_8 * AutoMM) / 100.0 * AccountFreeMargin() / g_lotstep_352 / (g_lotsize_360 / 100)) * g_lotstep_352)); ld_ret_0 >= 2.0 * g_minlot_336 &&
      1.05 * (ld_ret_0 * g_marginrequired_364) >= AccountFreeMargin(); ld_ret_0 -= g_minlot_336) {
   }
   return (ld_ret_0);
}

int CheckLossPause() {
   int datetime_4;
   bool li_ret_0 = TRUE;
   if (gi_304 > 0 && Hr > 0) {
      datetime_4 = 0;
      for (int pos_8 = OrdersHistoryTotal() - 1; pos_8 >= 0; pos_8--) {
         if (OrderSelect(pos_8, SELECT_BY_POS, MODE_HISTORY)) {
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic) {
               if (!((OrderType() == OP_BUY && (OrderClosePrice() - OrderOpenPrice()) / Pt <= (-gi_304)) || (OrderType() == OP_SELL && (OrderOpenPrice() - OrderClosePrice()) / Pt <= (-gi_304)))) break;
               datetime_4 = OrderCloseTime();
               break;
            }
         }
      }
      if (TimeCurrent() - datetime_4 < 3600 * Hr) li_ret_0 = FALSE;
   }
   return (li_ret_0);
}

int MyFirstInit() {
   if (UseCustomPair) gs_316 = StringSubstr(UseSettingsFrom, 0, 6);
   else gs_316 = StringSubstr(Symbol(), 0, 6);
   int li_ret_0 = SessionInit(AccountNo, IsTesting(), IsDemo(), WindowHandle(Symbol(), Period()), gs_316);
   if (li_ret_0 == -8 && StringFind(",EURUSD,GBPUSD,USDCHF,USDJPY,USDCAD,", "," + gs_316 + ",") >= 0) {
      Comment("\nUpdating settings (" + gs_316 + ")...");
      li_ret_0 = SessionDeinit(AccountNo, IsTesting(), IsDemo(), WindowHandle(Symbol(), Period()), gs_316);
      Sleep(3000);
      li_ret_0 = SessionInit(AccountNo, IsTesting(), IsDemo(), WindowHandle(Symbol(), Period()), gs_316);
   }
   if (li_ret_0 >= 0) {
      MaPeriod = ParamValue(li_ret_0, 1);
      gi_244 = ParamValue(li_ret_0, 2);
      gi_248 = ParamValue(li_ret_0, 3);
      gi_252 = ParamValue(li_ret_0, 4);
      gi_256 = ParamValue(li_ret_0, 5);
      gi_260 = ParamValue(li_ret_0, 6);
      gi_264 = ParamValue(li_ret_0, 7);
      WprPeriod = ParamValue(li_ret_0, 8);
      gi_272 = ParamValue(li_ret_0, 9);
      if (SecureProfit <= 0) SecureProfit = ParamValue(li_ret_0, 10);
      if (SecureProfitTriger <= 0) SecureProfitTriger = ParamValue(li_ret_0, 11);
      gi_276 = ParamValue(li_ret_0, 12);
      gi_280 = ParamValue(li_ret_0, 13);
      gi_284 = ParamValue(li_ret_0, 14);
      AtrLevel = ParamValue(li_ret_0, 15);
      AtrPeriod = ParamValue(li_ret_0, 16);
      gi_296 = ParamValue(li_ret_0, 17);
      CciPeriod = ParamValue(li_ret_0, 18);
      gi_304 = ParamValue(li_ret_0, 19);
      Hr = ParamValue(li_ret_0, 20);
      if (StopLoss <= 0) StopLoss = ParamValue(li_ret_0, 21);
      if (TakeProfit <= 0) TakeProfit = ParamValue(li_ret_0, 22);
   }
   Print("Using ",Symbol()," settings ...");
   Print("MaPeriod=",ParamValue(li_ret_0,1));
   Print("WprPeriod=",ParamValue(li_ret_0,8));
   Print("AtrLevel=",Pt*ParamValue(li_ret_0,15));
   Print("AtrPeriod=",ParamValue(li_ret_0,16));
   Print("CciPeriod=",ParamValue(li_ret_0,18));
   Print("StopLoss=",ParamValue(li_ret_0,21));
   Print("TakeProfit=",ParamValue(li_ret_0,22));
   
   return (li_ret_0);
}

int MyDeinit() {
   int li_ret_0;
   if (UseCustomPair) li_ret_0 = SessionDeinit(AccountNo, IsTesting(), IsDemo(), WindowHandle(Symbol(), Period()), StringSubstr(UseSettingsFrom, 0, 6));
   else li_ret_0 = SessionDeinit(AccountNo, IsTesting(), IsDemo(), WindowHandle(Symbol(), Period()), StringSubstr(Symbol(), 0, 6));
   return (li_ret_0);
}

int CloseLong(double ad_0, double ad_8, double ad_16, double ad_24, double ad_32) {
   bool li_40 = FALSE;
   li_40 = CheckCloseLong(SymbolType, ad_0, ad_8, ad_16, ad_24, ad_32, gi_264, Bid, Ask, Pt);
   return (li_40);
}

int CloseShort(double ad_0, double ad_8, double ad_16, double ad_24, double ad_32) {
   bool li_40 = FALSE;
   li_40 = CheckCloseShort(SymbolType, ad_0, ad_8, ad_16, ad_24, ad_32, gi_264, Bid, Ask, Pt);
   return (li_40);
}

int OpenLong(double Close1, double Ma1, double Wpr1, double Cci1) {
   bool li_32 = FALSE;
   li_32 = CheckOpenLong(SymbolType, Close1, Ma1, Wpr1, Cci1, gi_296, Bid, Ask, Pt);
   return (li_32);
}

int OpenShort(double Close1, double Ma1, double Wpr1, double Cci1) {
   bool li_32 = FALSE;
   li_32 = CheckOpenShort(SymbolType, Close1, Ma1, Wpr1, Cci1, gi_296, Bid, Ask, Pt);
   return (li_32);
}

//|-----------------------------------------------------------------------------------------|
//|                              C R E A T E   T R E N D L I N E                            |
//|-----------------------------------------------------------------------------------------|
bool TrendLinexCreate(string LinexName, double tradeEntryPrice, string desc="")
{
            if (ObjectFind(LinexName)<0)
            {
                //--- No previous object, so create a new object.
                ObjectCreate(LinexName,OBJ_TREND,0,iTime(NULL,0,150),tradeEntryPrice,iTime(NULL,0,0),tradeEntryPrice);
                if (desc!="") ObjectSetText(LinexName,desc);
            }
            
            if (ObjectFind(LinexName)<0)
            {
               Print("Unable to create TrendLinex ",LinexName);
            }
}

double CalcEntryPrice(int ordtype, int limit, double tradeEntryPrice, double wide)
{
    double calcPrice=tradeEntryPrice;
    if(ordtype==OP_BUY)
    {
        if(limit==1) calcPrice-=wide;
        else calcPrice+=wide;
    }
    else if(ordtype==OP_SELL)
    {
        if(limit==1) calcPrice+=wide;
        else calcPrice-=wide;
    }
    return(calcPrice);
}

int EasyCountLosingTradesMagic(int mgc, int max)
{
   int losingTrades=0;

//---- Assert determine count of all trades done with this MagicNumber
   for(int j=0;j<max;j++)
   {
      OrderSelect(j,SELECT_BY_POS,MODE_TRADES);

   //---- Assert MagicNumber and Symbol is same as Order
      if (OrderMagicNumber()==mgc && OrderSymbol()==Symbol() && OrderProfit()<0)
         losingTrades++;
   }
   return(losingTrades);
}

//|-----------------------------------------------------------------------------------------|
//|                       E N D   O F   E X P E R T   A D V I S O R                         |
//|-----------------------------------------------------------------------------------------|

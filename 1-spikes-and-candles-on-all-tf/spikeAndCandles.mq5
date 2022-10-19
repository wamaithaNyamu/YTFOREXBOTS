//+------------------------------------------------------------------+
//|                                              spikeAndCandles.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

// global varibales

string isCandleOrSpike  ="";

string boomOrCrash ="";

int startBars =0 ;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

   string symbolName = _Symbol;

   if(StringFind(symbolName, "Boom") != -1)
     {

      boomOrCrash="Boom";

     }
   else
      if(StringFind(symbolName, "Crash") != -1)
        {

         boomOrCrash="Crash";

        };

// get the iitial bars

   startBars = iBars(_Symbol, PERIOD_CURRENT);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

/*

// get the current candlestick
   double closeForCurrentCandle = iClose(_Symbol,PERIOD_CURRENT,0);
   double openForCurrentCandle = iOpen(_Symbol,PERIOD_CURRENT,0);


// if in boom
   if(boomOrCrash == "Boom")
     {

      if(openForCurrentCandle < closeForCurrentCandle)
        {

         isCandleOrSpike = "Spike";
        }
      else
         if(openForCurrentCandle > closeForCurrentCandle)
           {
            isCandleOrSpike="Candle";

           }

     }
   else
      if(boomOrCrash == "Crash")
        {
         if(openForCurrentCandle > closeForCurrentCandle)
           {

            isCandleOrSpike = "Spike";
           }
         else
            if(openForCurrentCandle < closeForCurrentCandle)
              {
               isCandleOrSpike="Candle";

              }

        };
        */

//


   Print("On tick");

   int newBars = iBars(_Symbol, PERIOD_CURRENT);

   if(newBars > startBars)
     {

      double closeForLastCandle = iClose(_Symbol,PERIOD_CURRENT,1);
      double openForLastCandle = iOpen(_Symbol,PERIOD_CURRENT,1);


      
      // if in boom
   if(boomOrCrash == "Boom")
     {

      if(openForLastCandle < closeForLastCandle)
        {

         isCandleOrSpike = "Spike";
        }
      else
         if(openForLastCandle > closeForLastCandle)
           {
            isCandleOrSpike="Candle";

           }

     }
   else
      if(boomOrCrash == "Crash")
        {
         if(openForLastCandle > closeForLastCandle)
           {

            isCandleOrSpike = "Spike";
           }
         else
            if(openForLastCandle < closeForLastCandle)
              {
               isCandleOrSpike="Candle";

              }

        };

      startBars = newBars;


     };




   Comment("The current chart is a ", boomOrCrash, " and the current candlestick is a ", isCandleOrSpike);



  }
//+------------------------------------------------------------------+

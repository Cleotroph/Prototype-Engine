// mod:core

/* Data Containers */
class Vec2 {
  float x, y;
  Vec2(float x, float y){
    this.x = x;
    this.y = y;
  }
}

/* LOGGING */
ArrayList<LogOutput> loggers;

// Interface for any log output you may choose to use; typically just a console out or file out.
interface LogOutput {
  void log(String identifier, LOGTYPE type, String s);  
}

// Initializes/resets the logging system.
void initLog(){
  loggers = new ArrayList<LogOutput>();
}

// Creates a stock java console logger and registers it.
void initDefaultLogger(){
  registerLogger(new LogOutput(){
    public void log(String identifier, LOGTYPE type, String s){
      println("[" + identifier + "/" + type + "]: " + s);  
    }
  });
}

void registerLogger(LogOutput out){
  loggers.add(out);
}

void logI(String identifier, String s){
  log(identifier, LOGTYPE.INFO, s);
}

void logW(String identifier, String s){
  log(identifier, LOGTYPE.WARN, s);
}

void logE(String identifier, String s){
  log(identifier, LOGTYPE.ERROR, s);
}

void log(String identifier, LOGTYPE type, String s){
  for(LogOutput out : loggers){
    out.log(identifier, type, s);  
  }
}

enum LOGTYPE{
  INFO {
      public String toString() {
          return "INFO";
      }
  },

  WARN {
      public String toString() {
          return "WARN";
      }
  },
  
  ERROR {
      public String toString() {
          return "ERROR";
      }
  }
}

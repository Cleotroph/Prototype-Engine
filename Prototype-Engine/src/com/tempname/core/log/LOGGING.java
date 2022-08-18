package com.tempname.core.log;

import java.util.ArrayList;

public class LOGGING {
    public static ArrayList<LogOutput> loggers;


    // Initializes/resets the logging system.
    public static void initLog(){
        loggers = new ArrayList<LogOutput>();
    }

    // Creates a stock java console logger and registers it.
    public static void initDefaultLogger(){
        registerLogger(new LogOutput(){
            public void log(String identifier, LOGTYPE type, String s){
                System.out.println("[" + identifier + "/" + type + "]: " + s);
            }
        });
    }

    public static void registerLogger(LogOutput out){
        loggers.add(out);
    }

    public static void logI(String identifier, String s){
        log(identifier, LOGTYPE.INFO, s);
    }

    public static void logW(String identifier, String s){
        log(identifier, LOGTYPE.WARN, s);
    }

    public static void logE(String identifier, String s){
        log(identifier, LOGTYPE.ERROR, s);
    }

    public static void log(String identifier, LOGTYPE type, String s){
        for(LogOutput out : loggers){
            out.log(identifier, type, s);
        }
    }

    public enum LOGTYPE{
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

    // Interface for any log output you may choose to use; typically just a console out or file out.
    public interface LogOutput {
        void log(String identifier, LOGTYPE type, String s);
    }
}

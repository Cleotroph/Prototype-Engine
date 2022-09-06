package com.tempname.core.serial;

import com.tempname.core.log.LOGGING;

import java.io.ByteArrayOutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.util.Collection;

public class Serializer {

    private static void serializePrimitive(Object o, Field f, Class<?> ft, SerializingOutputStream out) throws IllegalAccessException {
        if (ft == Integer.TYPE) {
            out.writeInt(f.getInt(o));
        } else if (ft == Boolean.TYPE) {
            out.write(f.getBoolean(o) ? 1 : 0);
        } else if (ft == Float.TYPE) {
            out.writeFloat(f.getFloat(o));
        } else if (ft == Double.TYPE) {
            out.writeDouble(f.getDouble(o));
        } else if (ft == Long.TYPE) {
            out.writeLong(f.getLong(o));
        } else if (ft == Character.TYPE) {
            out.write(f.getChar(o));
        } else if (ft == Byte.TYPE) {
            out.write(f.getByte(o));
        } else {
            LOGGING.logE("Serializer", "Unsupported primitive type " + ft);
        }
    }

    public static void Serialize(Object o, SerializingOutputStream out) throws NonSerializableObjectException, IllegalAccessException {
        Class<?> oc = o.getClass();
        if(oc.isAnnotationPresent(Serial.class)){
            for(Field f : oc.getFields()) {
                Class<?> ft = f.getType();
                System.out.println(ft + " : " + ft.isArray());
                if (f.isAnnotationPresent(Serial.class)) {
                    if (ft.isPrimitive()) {
                        serializePrimitive(o, f, ft, out);
                    } else if(ft.isArray()) {
                        Object[] oa = (Object[]) f.get(o);
                        out.writeInt(oa.length);
                        for(Object o1 : oa){
                            Serialize(o1, out);
                        }
                    } else {
                        Object fi = f.get(o);
                        if (fi instanceof String) {
                            String s = String.valueOf(fi);
                            out.writeInt(s.length());
                            out.writeBytes(s.getBytes());
                        }else{
                            Serialize(fi, out);
                        }
                    }
                }
            }
        }else{
            throw new NonSerializableObjectException("Class " + o.getClass().toString() + " is not Serializable!");
        }
    }

    public static byte[] Serialize(Object o) throws NonSerializableObjectException, IllegalAccessException {
        SerializingOutputStream out = new SerializingOutputStream();
        Serialize(o, out);
        return out.toByteArray();
    }

    public static <T> T Deserialize(byte[] data, Class<T> type) throws IllegalAccessException, InstantiationException, NonSerializableObjectException, SerializingInputStream.InvalidStreamLengthException {
        T o = type.newInstance();
        Class<?> oc = o.getClass();
        SerializingInputStream in = new SerializingInputStream(data);
        if(oc.isAnnotationPresent(Serial.class)){
            for(Field f : oc.getFields()) {
                Class<?> ft = f.getType();
                if (f.isAnnotationPresent(Serial.class)) {
                    if (ft.isPrimitive()) {
                        if (ft == Integer.TYPE) {
                            int a = in.readInt();
                            System.out.println("a = " + a);
                            f.setInt(o, a);
                        } else if (ft == Boolean.TYPE) {
                            //out.write(f.getBoolean(o) ? 1 : 0);
                        } else if (ft == Float.TYPE) {
                            //out.writeFloat(f.getFloat(o));
                        } else if (ft == Double.TYPE) {
                            //out.writeDouble(f.getDouble(o));
                        } else if (ft == Long.TYPE) {
                            f.setLong(o, in.readLong());
                        } else if (ft == Character.TYPE) {
                            //out.write(f.getChar(o));
                        } else if (ft == Byte.TYPE) {
                            //out.write(f.getByte(o));
                        } else {
                            LOGGING.logE("Serializer", "Unsupported primitive type " + ft);
                        }
                    }
                } else if (ft == String.class) {

                } else {
                    Object fi = f.get(o);
                    if (fi instanceof String) {
                        System.out.println(fi);
                    } else if (fi instanceof Collection<?>) {
                        System.out.println("YO found an array mr white");
                    }
                }
            }
        }else{
            throw new NonSerializableObjectException("Class " + o.getClass().toString() + " is not Serializable!");
        }
        return o;
    }

    private static class NonSerializableObjectException extends Exception{
        NonSerializableObjectException(String msg){
            super(msg);
        }
    }

}

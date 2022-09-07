package com.tempname.core.serial;

import com.tempname.core.log.LOGGING;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
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

    private static void deserializePrimitive(Object o, Field f, Class<?> ft, SerializingInputStream in) throws IllegalAccessException, SerializingInputStream.InvalidStreamLengthException, IOException {
        if (ft == Integer.TYPE) {
            int a = in.readInt();
            System.out.println("a = " + a);
            f.setInt(o, a);
        } else if (ft == Boolean.TYPE) {
            boolean a = in.readNBytes(1)[0] == 1;
            System.out.println("a = " + a);
            f.setInt(o, a);
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

    private static void serializePrimitiveArray(Object o, Field f, Class<?> ct, SerializingOutputStream out) throws IllegalAccessException {
        if (ct == Integer.TYPE) {
            int[] v = (int[]) f.get(o);
            out.writeInt(v.length);
            for(int e : v){
                out.writeInt(e);
            }
        } else if (ct == Boolean.TYPE) {
            boolean[] v = (boolean[]) f.get(o);
            out.writeInt(v.length);
            for(boolean e : v){
                out.write(f.getBoolean(o) ? 1 : 0);
            }
        } else if (ct == Float.TYPE) {
            float[] v = (float[]) f.get(o);
            out.writeInt(v.length);
            for(float e : v){
                out.writeFloat(e);
            }
        } else if (ct == Double.TYPE) {
            double[] v = (double[]) f.get(o);
            out.writeInt(v.length);
            for(double e : v){
                out.writeDouble(e);
            }
        } else if (ct == Long.TYPE) {
            long[] v = (long[]) f.get(o);
            out.writeInt(v.length);
            for(long e : v){
                out.writeLong(e);
            }
        } else if (ct == Character.TYPE) {
            char[] v = (char[]) f.get(o);
            out.writeInt(v.length);
            for(char e : v){
                out.writeInt(e);
            }
        } else if (ct == Byte.TYPE) {
            byte[] v = (byte[]) f.get(o);
            out.writeInt(v.length);
            for(byte e : v){
                out.write(e);
            }
        } else {
            LOGGING.logE("Serializer", "Unsupported primitive type " + ct);
        }
    }

    public static void Serialize(Object o, SerializingOutputStream out) throws NonSerializableObjectException, IllegalAccessException {
        Class<?> oc = o.getClass();
        if(oc.isAnnotationPresent(Serial.class)){
            for(Field f : oc.getFields()) {
                Class<?> ft = f.getType();
                if (f.isAnnotationPresent(Serial.class)) {
                    if (ft.isPrimitive()) {
                        serializePrimitive(o, f, ft, out);
                    } else if(ft.isArray()) {
                        System.out.println("casting array");
                        Class<?> ct = ft.getComponentType();
                        if(ct.isPrimitive()) {
                            serializePrimitiveArray(o, f, ct, out);
                        }else{
                            Object[] oa = (Object[]) f.get(o);
                            out.writeInt(oa.length);
                            for(Object o1 : oa){
                                Serialize(o1, out);
                            }
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
                    }else if (ft == String.class) {
                        int l = in.readInt();
                        byte[] buf = new byte[l];
                        in.read(buf, 0, l);
                        String s = new String(buf);
                        f.set(o, s);
                    } else {
                        Object fi = f.get(o);
                        if (fi instanceof String) {
                            System.out.println(fi);
                        } else if (fi instanceof Collection<?>) {
                            System.out.println("YO found an array mr white");
                        }
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

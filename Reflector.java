import java.lang.reflect.Field;
import java.lang.reflect.Method;

/**
 * <b>Reflection tool</b>
 *
 * <p>
 * This is a utility class and therefor should never be instanced!<br>
 * <br>
 * Be careful upon editing this file as you may break classes using it!<br>
 * <br>
 * This file contains a lot of small utilities' method to extract set and uses class, methods and fields from private files.<br>
 * <br>
 * All methods in this file automatically catch errors and print stackTrace when using it, be sure to check your console for any errors.<br>
 * <br>
 * You cannot instantiate constructor using this file and you will need to instantiate them in their respective file due to autoboxing.<br>
 * It could be possible to instantiate constructor taking only object as arguments, but almost all of them take primitive types making it impossible to extract.<br>
 * <br>
 * Take a look at the provided link for autoboxing explanation.<br>
 * </p>
 *
 * @see <a href="https://docs.oracle.com/javase/tutorial/java/data/autoboxing.html">https://docs.oracle.com/javase/tutorial/java/data/autoboxing.html</a>
 *
 * @author Florian Chanson
 */
public class Reflector {

    /**
     * <p>
     * Private constructor to prevent instancing.<br>
     * This class should never be instanced.<br>
     * </p>
     */
    private Reflector() {}

    /**
     * <b>Extract a class from a java package</b>
     *
     * <p>
     * Extract the class using the class package declaration + name<br>
     * <i>(e.g: com.google.android.mms.pdu.PduPart)</i><br>
     * <br>
     * The found class will be returned as a class capture or null if the file doesn't exist<br>
     * </p>
     * @param path the class path
     *
     * @return a capture of the class or null if not found
     */
    public static Class<?> getClass(String path) {
        try {
            return Class.forName(path);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * <b>Invoke a method and return its data</b>
     *
     * <p>
     * Invoke a method from a previously extracted class and return the method data.<br>
     * <br>
     * <b>WARNING</b> upon using this method with primitive types you must use their class version e.g:<br>
     * <i>int.class -> Integer.class<br>
     * boolean.class -> Boolean.class<br>
     * float.class -> Float.class<br>
     * ...</i><br>
     * <br>
     * Or you will get a cast error due to autoboxing.<br>
     * Take a look at the provided link for autoboxing explanation.<br>
     * </p>
     *
     * @see <a href="https://docs.oracle.com/javase/tutorial/java/data/autoboxing.html">https://docs.oracle.com/javase/tutorial/java/data/autoboxing.html</a><br>
     * <br>
     * For method that return nothing (void)
     * @see #invokeMethod(Method, Object, Object...)
     *
     * @param method the method that must be invoked
     * @param object the class object instance or null if the method is static
     * @param type the type of data returned by the method
     * @param args the method args
     *
     * @return the data provided by the invoked method
     *
     * @param <T> a template parameter allowing us to use this one method to return anything
     */
    public static <T> T invokeMethod(Method method, Object object, Class<T> type, Object... args) {
        try {
            return type.cast(method.invoke(object, args));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * <b>Invoke a method</b>
     *
     * <p>
     * Invoke a method from a previously extracted class.
     * </p>
     *
     * @see #invokeMethod(Method, Object, Class, Object...)
     *
     * @param method the method that must be invoked
     * @param object the class object instance or null if the method is static
     * @param args the method args
     */
    public static void invokeMethod(Method method, Object object, Object... args) {
        try {
            method.invoke(object, args);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * <b>Extract a method</b>
     *
     * <p>
     * Get a method from any previously extracted classes.<br>
     * The method is ready to run once extracted.<br>
     * <br>
     * You can also extract private/protected method.<br>
     * </p>
     *
     * @param classData the class containing the desired method
     * @param methodName the method name
     * @param args the method args
     *
     * @return the method ready to be invoked or null if not found
     */
    public static Method getMethod(Class<?> classData, String methodName, Class<?>... args) {
        try {
            final Method method = classData.getMethod(methodName, args);
            method.setAccessible(true);

            return method;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * <b>Set field value</b>
     * <p>
     * Allow you to manually set any class field value.<br>
     * <br>
     * In many classes is much safer to use class setter to do that, but if they are missing, or you need to update one specific value this is the method you need.<br>
     * <br>
     * With this method you can also access and set private/protected fields.<br>
     * </p>
     *
     * @param edit the object containing the field or null if the field is static
     * @param fieldName the name of the field that must be edited
     * @param value the value you want to put in the field
     */
    public static void setField(Object edit, String fieldName, Object value) {
        try {
            final Field field = edit.getClass().getDeclaredField(fieldName);

            field.setAccessible(true);
            field.set(edit, value);
        } catch (NoSuchFieldException | IllegalAccessException e) {
            e.printStackTrace();
        }
    }

    /**
     * <b>Extract objet field from classes</b>
     * <p>
     * Warning you cannot extract primitive types using this method due to autoboxing.<br>
     * <br>
     * Take a look at the provided link for autoboxing explanation.<br>
     * </p>
     * @see <a href="https://docs.oracle.com/javase/tutorial/java/data/autoboxing.html">https://docs.oracle.com/javase/tutorial/java/data/autoboxing.html</a><br>
     * <br>
     *
     * Use the appropriate method for each primitive:
     * @see #getInteger
     * @see #getIntegerArray
     * @see #getBoolean
     * @see #getBooleanArray
     * @see #getFloat
     * @see #getFloatArray
     * @see #getDouble
     * @see #getDoubleArray
     * @see #getLong
     * @see #getLongArray
     * @see #getShort
     * @see #getShortArray
     * @see #getByte
     * @see #getByteArray
     * @see #getChar
     * @see #getCharArray
     *
     * @param classData the class containing the desired object
     * @param fieldName the extracted field name
     * @param object the class object instance or null if the field is static
     * @param type the type of class expected to be returned
     *
     * @return the field value or null if not found
     *
     * @param <T> template object allowing us to return any type of object with only one function
     */
    public static <T> T getObject(Class<?> classData, String fieldName, Object object, Class<T> type) {
        try {
            final Field field = classData.getDeclaredField(fieldName);
            field.setAccessible(true);

            return type.cast(field.get(object));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * <b>Return an integer field value</b>
     *
     * @param classData the class containing the field
     * @param fieldName the name of the extracted field
     * @param object the integer value or -1 if not found
     *
     * @return the field value
     */
    public static int getInteger(Class<?> classData, String fieldName, Object object) {
        try {
            final Field field = classData.getDeclaredField(fieldName);
            field.setAccessible(true);

            return field.getInt(object);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * <b>Return an integer array field value</b>
     *
     * @param classData the class containing the field
     * @param fieldName the name of the extracted field
     * @param object the integer array or an empty integer array if not found
     *
     * @return the field value
     */
    public static int[] getIntegerArray(Class<?> classData, String fieldName, Object object) {
        try {
            final Field field = classData.getDeclaredField(fieldName);
            field.setAccessible(true);

            return (int[]) (field.get(object));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new int[] {};
    }

    /**
     * <b>Return a boolean field value</b>
     *
     * @param classData the class containing the field
     * @param fieldName the name of the extracted field
     * @param object the boolean value or false if not found
     *
     * @return the field value
     */
    public static boolean getBoolean(Class<?> classData, String fieldName, Object object) {
        try {
            final Field field = classData.getDeclaredField(fieldName);
            field.setAccessible(true);

            return field.getBoolean(object);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * <b>Return a boolean array field value</b>
     *
     * @param classData the class containing the field
     * @param fieldName the name of the extracted field
     * @param object the boolean array or an empty boolean array if not found
     *
     * @return the field value
     */
    public static boolean[] getBooleanArray(Class<?> classData, String fieldName, Object object) {
        try {
            final Field field = classData.getDeclaredField(fieldName);
            field.setAccessible(true);

            return (boolean[]) (field.get(object));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new boolean[] {};
    }

    /**
     * <b>Return a float field value</b>
     *
     * @param classData the class containing the field
     * @param fieldName the name of the extracted field
     * @param object the float value or -1 if not found
     *
     * @return the field value
     */
    public static float getFloat(Class<?> classData, String fieldName, Object object) {
        try {
            final Field field = classData.getDeclaredField(fieldName);
            field.setAccessible(true);

            return field.getFloat(object);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * <b>Return a float array field value</b>
     *
     * @param classData the class containing the field
     * @param fieldName the name of the extracted field
     * @param object the float array or a new empty float array if not found
     *
     * @return the field value
     */
    public static float[] getFloatArray(Class<?> classData, String fieldName, Object object) {
        try {
            final Field field = classData.getDeclaredField(fieldName);
            field.setAccessible(true);

            return (float[]) (field.get(object));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new float[] {};
    }

    /**
     * <b>Return a double field value</b>
     *
     * @param classData the class containing the field
     * @param fieldName the name of the extracted field
     * @param object the double value or -1 if not found
     *
     * @return the field value
     */
    public static double getDouble(Class<?> classData, String fieldName, Object object) {
        try {
            final Field field = classData.getDeclaredField(fieldName);
            field.setAccessible(true);

            return field.getDouble(object);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * <b>Return a double array field value</b>
     *
     * @param classData the class containing the field
     * @param fieldName the name of the extracted field
     * @param object the double array or a new empty double array if not found
     *
     * @return the field value
     */
    public static double[] getDoubleArray(Class<?> classData, String fieldName, Object object) {
        try {
            final Field field = classData.getDeclaredField(fieldName);
            field.setAccessible(true);

            return (double[]) (field.get(object));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new double[] {};
    }

    /**
     * <b>Return a long field value</b>
     *
     * @param classData the class containing the field
     * @param fieldName the name of the extracted field
     * @param object the long value or -1 if not found
     *
     * @return the field value
     */
    public static long getLong(Class<?> classData, String fieldName, Object object) {
        try {
            final Field field = classData.getDeclaredField(fieldName);
            field.setAccessible(true);

            return field.getLong(object);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * <b>Return a long array field value</b>
     *
     *
     * @param classData the class containing the field
     * @param fieldName the name of the extracted field
     * @param object the long array or a new empty long array if not found
     *
     * @return the field value
     */
    public static long[] getLongArray(Class<?> classData, String fieldName, Object object) {
        try {
            final Field field = classData.getDeclaredField(fieldName);
            field.setAccessible(true);

            return (long[]) (field.get(object));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new long[] {};
    }

    /**
     * <b>Return a short field value</b>
     *
     *
     * @param classData the class containing the field
     * @param fieldName the name of the extracted field
     * @param object the short value or -1 if not found
     *
     * @return the field value
     */
    public static short getShort(Class<?> classData, String fieldName, Object object) {
        try {
            final Field field = classData.getDeclaredField(fieldName);
            field.setAccessible(true);

            return field.getShort(object);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * <b>Return a short array field value</b>
     *
     *
     * @param classData the class containing the field
     * @param fieldName the name of the extracted field
     * @param object the short array or a new empty short array if not found
     *
     * @return the field value
     */
    public static short[] getShortArray(Class<?> classData, String fieldName, Object object) {
        try {
            final Field field = classData.getDeclaredField(fieldName);
            field.setAccessible(true);

            return (short[]) (field.get(object));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new short[] {};
    }

    /**
     * <b>Return a byte field value</b>
     *
     *
     * @param classData the class containing the field
     * @param fieldName the name of the extracted field
     * @param object the byte value of -1 if not found
     *
     * @return the field value
     */
    public static byte getByte(Class<?> classData, String fieldName, Object object) {
        try {
            final Field field = classData.getDeclaredField(fieldName);
            field.setAccessible(true);

            return field.getByte(object);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * <b>Return a byte array field value</b>
     *
     *
     * @param classData the class containing the field
     * @param fieldName the name of the extracted field
     * @param object the byte array of a new empty byte array if not found
     *
     * @return the field value
     */
    public static byte[] getByteArray(Class<?> classData, String fieldName, Object object) {
        try {
            final Field field = classData.getDeclaredField(fieldName);
            field.setAccessible(true);

            return (byte[]) (field.get(object));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new byte[] {};
    }

    /**
     * <b>Return a char field value</b>
     *
     *
     * @param classData the class containing the field
     * @param fieldName the name of the extracted field
     * @param object the char value of \0 if not found
     *
     * @return the field value
     */
    public static char getChar(Class<?> classData, String fieldName, Object object) {
        try {
            final Field field = classData.getDeclaredField(fieldName);
            field.setAccessible(true);

            return field.getChar(object);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return '\0';
    }

    /**
     * <b>Return a char array field value</b>
     *
     *
     * @param classData the class containing the field
     * @param fieldName the name of the extracted field
     * @param object the char array or a new empty char array if not found
     *
     * @return the field value
     */
    public static char[] getCharArray(Class<?> classData, String fieldName, Object object) {
        try {
            final Field field = classData.getDeclaredField(fieldName);
            field.setAccessible(true);

            return (char[]) (field.get(object));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new char[] {};
    }
}


import com.tempname.core.serial.Serial;
import com.tempname.core.serial.Serializer;
import processing.core.PApplet;

public class Main extends PApplet {
    public static void main(String[] args) {
        System.out.println("Hello world!");
        Main c = new Main();
        c.init();
    }
    public void init(){
        try {
            //Test t = Serializer.Deserialize(new byte[0], Test.class);
            //System.out.println(t.s);

            Test t1 = new Test();
            t1.a = 24;
            t1.l = 69;
            t1.d = 0.69;
            t1.f = 1.69f;
            t1.s = "NO?";
            t1.arr = new int[] {2, 3, 4};

            byte[] buf = Serializer.Serialize(t1);
            Test t2 = Serializer.Deserialize(buf, Test.class);
            System.out.println("In: " + t1.a + "\t:\t" + t1.d + "\t:\t" + t1.l + "\t:\t" + t1.f + "\t:\t" + t1.s );
            System.out.println(new String(buf));
            System.out.println("Out: " + t2.a + "\t:\t" + t1.d + "\t:\t" + t1.l + "\t:\t" + t1.f + "\t:\t" + t2.s);

        }catch (Exception e){
            System.out.println("oops: " + e);
        }



        /*String s = "";
        System.out.println(s.getClass().isPrimitive());

        Test t = new Test();
        try {
            println("running serial test");
            Serializer.Serialize(t);
        }catch (Exception e){
            println(e);
        }

        super.main("Main");*/
    }

    @Serial
    public static class Test{
        @Serial
        public int a = 7;
        @Serial
        public float f = 0.5f;
        @Serial
        public long l = 1000L;
        @Serial
        public double d = 0.5;
        @Serial
        public String s = "YO";
        @Serial
        public int[] arr = {1, 2, 3};
    }

}
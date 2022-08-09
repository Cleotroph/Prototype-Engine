// mod:core

// defines a generic registry with a user defined key and value.
// designed to be built at init and then subsequently finalized to be unmodifiable.
class Registry<K, T> {
  boolean finalized = false;
  HashMap<K, T> entries;
  Registry(){
    entries = new HashMap<K, T>();
  }
  void finalize(){
    finalized = true;
    logI("Registry<"+", "+">", "Registered " + entries.size() + " items.");
  }
  void register(T entry, K id){
    if(!finalized){
      entries.put(id, entry);
    }else{
      // TODO: Throw illegal modification exception
      //throw new Exception();  
      println("illegalModification");
      exit();
    }
  }
}

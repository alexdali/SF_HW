public with sharing class ListUtils {
    // public ListUtils() {

    // }
    public static List<Object> slice(List<Object> input, Integer ge, Integer l) {
        List<Object> output = input.clone();
        for (Integer i = 0; i < ge; i++) output.remove(0);
        Integer elements = l - ge;
        while (output.size() > elements) output.remove(elements);
        return output;
    }
}



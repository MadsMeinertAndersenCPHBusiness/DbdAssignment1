public class Dog extends Pet {
    private String BarkPitch;

    public Dog(int id, String name, int age, String vet_cvr, String barkPitch) {
        super(id, name, age, vet_cvr);
        this.BarkPitch = barkPitch;
    }

    public String getBarkPitch() {
        return BarkPitch;
    }

    public void setBarkPitch(String barkPitch) {
        BarkPitch = barkPitch;
    }
}

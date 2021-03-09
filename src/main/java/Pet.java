public class Pet {
    private int id;
    private String name;
    private int age;
    private String vet_cvr;

    public Pet(int id, String name, int age, String vet_cvr) {
        this.id = id;
        this.name = name;
        this.age = age;
        this.vet_cvr = vet_cvr;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getVet_cvr() {
        return vet_cvr;
    }

    public void setVet_cvr(String vet_cvr) {
        this.vet_cvr = vet_cvr;
    }
}

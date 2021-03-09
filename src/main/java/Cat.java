public class Cat extends Pet {
    private int lifeCount;

    public Cat(int id, String name, int age, String vet_cvr, int lifeCount) {
        super(id, name, age, vet_cvr);
        this.lifeCount = lifeCount;
    }

    public int getLifeCount() {
        return lifeCount;
    }

    public void setLifeCount(int lifeCount) {
        this.lifeCount = lifeCount;
    }
}

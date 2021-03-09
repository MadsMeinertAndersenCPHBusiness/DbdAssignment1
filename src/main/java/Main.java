import java.sql.SQLException;

public class Main {
    public static void main(String[] args) throws SQLException {
        PetService petService = new PetService("username", "password");

        petService.addPet("Oink", 100, "12345678");
        petService.addCat("Meow", 4, "12345678", 9);
        petService.addDog("Wuf", 5, "12345678",  "C2");

        for (Pet pet: petService.getPets()) {

            System.out.println(pet.getName() + " is a "+ pet.getClass().getName());
        }
    }
}

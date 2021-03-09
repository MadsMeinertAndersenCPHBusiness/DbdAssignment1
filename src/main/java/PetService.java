import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;

public class PetService {
    private String username;
    private String password;
    public PetService(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public Collection<Pet> getPets() throws SQLException {
        Collection<Pet> pets = new ArrayList<>();
        try(Connection connection = DbDriverManager.getConnection(username, password)){
            String sql = "SELECT * FROM pets";
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            try (ResultSet resultSet = preparedStatement.executeQuery()){
                while (resultSet.next()){
                    Pet pet;
                    if (resultSet.getInt(5) == 0 && resultSet.getString(6) == null){
                        pet = new Pet(resultSet.getInt(1), resultSet.getString(2),
                                resultSet.getInt(3), resultSet.getString(4));
                    }else if (resultSet.getString(6) == null){
                        pet = new Cat(resultSet.getInt(1), resultSet.getString(2),
                                resultSet.getInt(3), resultSet.getString(4), resultSet.getInt(5));
                    }else{
                        pet = new Dog(resultSet.getInt(1), resultSet.getString(2),
                                resultSet.getInt(3), resultSet.getString(4), resultSet.getString(6));
                    }
                    pets.add(pet);

                }

            }
        }
        return pets;
    }
    public void addPet(String name, int age, String vet_cvr) throws SQLException {
        try(Connection connection = DbDriverManager.getConnection(username, password)){

        String sql = "CALL INSERT_PET(?, ?, ?)";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1,name);
        preparedStatement.setInt(2, age);
        preparedStatement.setString(3,vet_cvr);
        preparedStatement.executeUpdate();
        }
    }
    public void addCat(String name, int age, String vet_cvr, int lifeCount) throws SQLException {
        try(Connection connection = DbDriverManager.getConnection(username, password)){

            String sql = "CALL INSERT_CAT(?, ?, ?, ?)";
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1,name);
            preparedStatement.setInt(2, age);
            preparedStatement.setString(3,vet_cvr);
            preparedStatement.setInt(4, lifeCount);
            preparedStatement.executeUpdate();
        }
    }
    public void addDog(String name, int age, String vet_cvr, String barkPitch) throws SQLException {
        try(Connection connection = DbDriverManager.getConnection(username, password)){

            String sql = "CALL INSERT_DOG(?, ?, ?, ?)";
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1,name);
            preparedStatement.setInt(2, age);
            preparedStatement.setString(3,vet_cvr);
            preparedStatement.setString(4, barkPitch);
            preparedStatement.executeUpdate();
        }
    }
}

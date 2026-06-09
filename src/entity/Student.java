package entity;

public class Student {
    private int id;
    private String sno;
    private String sname;
    private String gender;
    private int age;
    private String major;
    private double grade;

    public Student() {}

    public Student(String sno, String sname, String gender, int age, String major, double grade) {
        this.sno = sno;
        this.sname = sname;
        this.gender = gender;
        this.age = age;
        this.major = major;
        this.grade = grade;
    }

    public Student(int id, String sno, String sname, String gender, int age, String major, double grade) {
        this.id = id;
        this.sno = sno;
        this.sname = sname;
        this.gender = gender;
        this.age = age;
        this.major = major;
        this.grade = grade;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getSno() { return sno; }
    public void setSno(String sno) { this.sno = sno; }

    public String getSname() { return sname; }
    public void setSname(String sname) { this.sname = sname; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }

    public String getMajor() { return major; }
    public void setMajor(String major) { this.major = major; }

    public double getGrade() { return grade; }
    public void setGrade(double grade) { this.grade = grade; }

    @Override
    public String toString() {
        return "Student{id=" + id + ", sno='" + sno + "', sname='" + sname
                + "', gender='" + gender + "', age=" + age + ", major='" + major
                + "', grade=" + grade + "}";
    }
}

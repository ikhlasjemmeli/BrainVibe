namespace Brainvibe.EF.Models
{
    public class Category
    {
        public int Id { get; set; }
        public string CoverImage { get; set; }
        public string Name { get; set; }
        public int NoOfCourse { get; set; }
        public int UserId { get; set; } 
        public User User { get; set; }
    }

}

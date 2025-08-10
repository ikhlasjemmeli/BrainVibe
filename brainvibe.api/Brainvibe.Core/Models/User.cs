using System.Text.Json.Serialization;

namespace Brainvibe.EF.Models
{
    public class User
    {
        public int Id { get; set; }
        public string Email { get; set; }
        [JsonIgnore]
        public string Password { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string? ProfilePicture { get; set; }
        public bool IsActive { get; set; }
        public string Role { get; set; }  
        

        public ICollection<Category> Categories { get; set; } // si Admin
    }
}

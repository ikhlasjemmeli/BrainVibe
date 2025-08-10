using Brainvibe.EF.Models;

namespace Brainvibe.Core.Dtos
{
    public class AuthResponseDto
    {
        public string Token { get; set; }
        public string Role { get; set; }
        public User User { get; set; }
    }
}

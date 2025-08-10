using Brainvibe.Core.Dtos;
using Brainvibe.EF.Models;

namespace Brainvibe.Core.Services.Interfaces
{
    public interface IAuthService
    {
        Task RegisterAsync(RegisterDto dto);
        Task<AuthResponseDto> LoginAsync(LoginDto dto);
        IEnumerable<User> GetAllUsersAsync();
  
        Task DeleteAccountAsync(int userId);

        Task ChangePasswordAsync(int userId, ChangePasswordDto dto);
        Task<User> GetUserByIdAsync(int id);
        Task UpdateProfileAsync(int userId, UpdateProfileDto dto);
        Task DisableAccountAsync(int userId);




    }
}

using Brainvibe.Core.Services.Interfaces;
using Brainvibe.Core.Dtos;
using Brainvibe.Core.interfaces;
using Microsoft.Extensions.Configuration;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.IdentityModel.Tokens;
using System.Security.Claims;

using System.Text;

using Brainvibe.EF.Models;


using bCrypt = BCrypt.Net.BCrypt;

namespace Brainvibe.Core.Services.Implementations
{
    public class AuthService : IAuthService
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IConfiguration _configuration;

        public AuthService(IUnitOfWork unitOfWork, IConfiguration configuration)
        {
            _unitOfWork = unitOfWork;
            _configuration = configuration;
        }

        public async Task RegisterAsync(RegisterDto dto)
        {
            var userExist = await _unitOfWork.Users.FindByEmailAsync(dto.Email);
            if (userExist != null)
                throw new Exception("Email déjà utilisé.");

            var user = new User
            {
                
                Email = dto.Email,
                Password = bCrypt.HashPassword(dto.Password),
                FirstName = dto.FirstName,
                LastName = dto.LastName,
                Role = "User",
                IsActive = true,
               
            };

            await _unitOfWork.Users.AddAsync(user);
            await _unitOfWork.CompleteAsync();
        }

        public async Task<AuthResponseDto> LoginAsync(LoginDto dto)
        {
            var user = await _unitOfWork.Users.FindByEmailAsync(dto.Email);
            if (user == null || !bCrypt.Verify(dto.Password, user.Password))
                throw new Exception("Email ou mot de passe incorrect.");


            if (!user.IsActive)
            {
                user.IsActive = true;
                _unitOfWork.Users.Update(user);
                await _unitOfWork.CompleteAsync();
            }
            var token = GenerateJwtToken(user, dto.RememberMe);
            return new AuthResponseDto
            {
                Token = token,
                Role = user.Role,
                User = user
            };
        }

        private string GenerateJwtToken(User user, bool rememberMe)
        {
            var claims = new[]
            {
                new Claim("id", user.Id.ToString()),
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Role, user.Role)
            };

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
            var tokenExpiration = rememberMe ? DateTime.Now.AddDays(30) : DateTime.Now.AddDays(7);
            var token = new JwtSecurityToken(
                issuer: _configuration["Jwt:Issuer"],
                audience: _configuration["Jwt:Audience"],
                claims: claims,
                expires: tokenExpiration,
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        public  IEnumerable<User> GetAllUsersAsync()
        {
            return  _unitOfWork.Users.GetAll();
        }

     

        public async Task DeleteAccountAsync(int userId)
        {
            var user = await _unitOfWork.Users.GetByIdAsync(userId);
            if (user == null)
                throw new Exception("Utilisateur non trouvé.");

            _unitOfWork.Users.Remove(user);
            await _unitOfWork.CompleteAsync();
        }

        public async Task ChangePasswordAsync(int userId, ChangePasswordDto dto)
        {
            var user = await _unitOfWork.Users.GetByIdAsync(userId);
            if (user == null)
                throw new Exception("Utilisateur non trouvé.");

            bool passwordValid = BCrypt.Net.BCrypt.Verify(dto.OldPassword, user.Password);
            if (!passwordValid)
                throw new Exception("Ancien mot de passe incorrect.");

            user.Password = BCrypt.Net.BCrypt.HashPassword(dto.NewPassword);
            _unitOfWork.Users.Update(user);
            await _unitOfWork.CompleteAsync();
        }



        public async Task<User> GetUserByIdAsync(int id)
        {
            var user = await _unitOfWork.Users.GetByIdAsync(id);
            if (user == null)
                throw new Exception("Utilisateur non trouvé.");

            return new User
            {
                Id = user.Id,
                Email = user.Email,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Role = user.Role
            };
        }


        public async Task UpdateProfileAsync(int userId, UpdateProfileDto dto)
        {
            var user = await _unitOfWork.Users.GetByIdAsync(userId);
            if (user == null)
                throw new Exception("Utilisateur non trouvé.");

            user.FirstName = dto.FirstName;
            user.LastName = dto.LastName;
            user.ProfilePicture = dto.ProfilePicture;

            _unitOfWork.Users.Update(user);
            await _unitOfWork.CompleteAsync();
        }



        public async Task DisableAccountAsync(int userId)
        {
            var user = await _unitOfWork.Users.GetByIdAsync(userId);
            if (user == null)
                throw new Exception("Utilisateur non trouvé.");

            user.IsActive = false;
            _unitOfWork.Users.Update(user);
            await _unitOfWork.CompleteAsync();
        }




    }
}

using Brainvibe.Core.Dtos;
using Brainvibe.Core.interfaces;
using Brainvibe.EF.Models;
using Microsoft.Extensions.Configuration;
using BCrypt.Net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace Brainvibe.EF.Repositories
{
    public class UserRepository : Repository<User>, IUserRepository
    {
        public readonly ApplicationDbContext _context;
      
        public UserRepository(ApplicationDbContext context) : base(context)
        {
            _context = context;
           
        }

        public async Task<User> FindByEmailAsync(string email)
        {
            return await _context.Users.FirstOrDefaultAsync(u => u.Email == email);
        }
        public async Task AddAsync(User user)
        {
            await _context.Users.AddAsync(user);
        }

        public async Task<User> GetByIdAsync(int id)
        {
            return await _context.Users.FirstOrDefaultAsync(u => u.Id == id);
        }
    }
}

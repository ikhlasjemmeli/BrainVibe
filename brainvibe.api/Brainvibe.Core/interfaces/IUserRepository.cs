using Brainvibe.Core.Dtos;
using Brainvibe.EF.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Brainvibe.Core.interfaces
{
    public interface IUserRepository : IRepository<User>
    {
        Task<User> FindByEmailAsync(string email);
        Task AddAsync(User user);
        Task<User> GetByIdAsync(int id);
        
    }
}

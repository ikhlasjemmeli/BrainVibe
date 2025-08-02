using Brainvibe.EF.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Brainvibe.Core.interfaces
{
    public interface ICategoryRepository : IRepository<Category>
    {
        
        Task AddAsync(Category category);
        Task DeleteAsync(int id);
      
       

    }
}

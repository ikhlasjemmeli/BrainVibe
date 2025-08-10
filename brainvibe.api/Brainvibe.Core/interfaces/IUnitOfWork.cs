using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Brainvibe.Core.interfaces
{
    public interface IUnitOfWork :IDisposable
    {
        ICategoryRepository Categories { get; }
        IUserRepository Users { get; }
        Task<int> CompleteAsync();
    }
}

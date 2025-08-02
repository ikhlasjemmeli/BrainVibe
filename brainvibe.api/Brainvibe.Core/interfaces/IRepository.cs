using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace Brainvibe.Core.interfaces
{
    public interface IRepository<T> where T : class
    {
        IEnumerable<T> GetAll();
        void Add(T item);
        void Remove(T item);
        void Update( T item);
        Task<T> GetByIdAsync(int id);
    }
}

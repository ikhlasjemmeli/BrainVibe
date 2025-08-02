using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Brainvibe.EF.Models
{
    public class Category
    {
        public int Id { get; set; }
        public string CoverImage { get; set; }
        public string Name { get; set; }
        public int NoOfCourse { get; set; }
    }

}

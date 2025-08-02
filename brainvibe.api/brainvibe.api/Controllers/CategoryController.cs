using Brainvibe.Core.Dtos;
using Brainvibe.Core.interfaces;
using Brainvibe.EF.Models;
using Microsoft.AspNetCore.Mvc;

namespace brainvibe.api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CategoryController : ControllerBase
    {
        private readonly IUnitOfWork _unitOfWork;

        public CategoryController(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        [HttpGet]
        public IActionResult GetAll()
        {
            var categories = _unitOfWork.Categories.GetAll();
            return Ok(categories);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Category>> GetCategoryById(int id)
        {
            var category = await _unitOfWork.Categories.GetByIdAsync(id);

            if (category == null)
                return NotFound($"La catégorie avec l'ID {id} est introuvable.");

            return Ok(category);
        }


        [HttpPost]
        public async Task<ActionResult> Add(CategoryDto categoryDto)
        {
            var category = new Category
            {
                Name = categoryDto.Name,
                CoverImage = categoryDto.CoverImage,

                NoOfCourse = categoryDto.NoOfCourse

            };

            await _unitOfWork.Categories.AddAsync(category);
            await _unitOfWork.CompleteAsync();


            return Created(string.Empty, category);
        }


        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            await _unitOfWork.Categories.DeleteAsync(id);
            await _unitOfWork.CompleteAsync();
            return NoContent();
        }
    }
}

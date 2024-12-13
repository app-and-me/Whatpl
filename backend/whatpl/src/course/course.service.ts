import { Inject, Injectable } from '@nestjs/common';
import { CreateCourseDto } from './dto/create-course.dto';
import { UpdateCourseDto } from './dto/update-course.dto';
import { Course } from './entities/course.entity';
import { ResponseStrategy } from '../shared/strategies/response.strategy';
import { AppRepository } from 'src/app.repository';

@Injectable()
export class CourseService {
  constructor(
    @Inject('COURSE_REPOSITORY')
    private courseRepository: AppRepository<Course>,
    private responseStrategy: ResponseStrategy,
  ) {}

  async create(createCourseDto: CreateCourseDto) {
    try {
      const course: Course = {
        ...createCourseDto,
      };
      const id = await this.courseRepository.create(course);
      return this.responseStrategy.success('Course created successfully', {
        id,
        ...course,
      });
    } catch (error) {
      return this.responseStrategy.error('Failed to create course', error);
    }
  }

  async findAll() {
    try {
      const courses = await this.courseRepository.findAll();
      return courses.length === 0
        ? this.responseStrategy.noContent('No courses found')
        : this.responseStrategy.success(
            'Courses retrieved successfully',
            courses,
          );
    } catch (error) {
      return this.responseStrategy.error('Failed to retrieve courses', error);
    }
  }

  async findOne(id: string) {
    try {
      const course = await this.courseRepository.findOne(id);
      return course
        ? this.responseStrategy.success('Course retrieved successfully', course)
        : this.responseStrategy.notFound('Course not found');
    } catch (error) {
      return this.responseStrategy.error('Failed to retrieve course', error);
    }
  }

  async update(id: string, updateCourseDto: UpdateCourseDto) {
    try {
      const existingCourse = await this.courseRepository.findOne(id);
      if (!existingCourse) {
        return this.responseStrategy.notFound('Course not found');
      }
      const updatedCourse: Partial<Course> = {
        ...updateCourseDto,
      };
      await this.courseRepository.update(id, updatedCourse);
      return this.responseStrategy.success('Course updated successfully', {
        id,
        ...existingCourse,
        ...updatedCourse,
      });
    } catch (error) {
      return this.responseStrategy.error('Failed to update course', error);
    }
  }

  async remove(id: string) {
    try {
      const existingCourse = await this.courseRepository.findOne(id);
      if (!existingCourse) {
        return this.responseStrategy.notFound('Course not found');
      }
      await this.courseRepository.remove(id);
      return this.responseStrategy.success('Course deleted successfully');
    } catch (error) {
      return this.responseStrategy.error('Failed to delete course', error);
    }
  }
}

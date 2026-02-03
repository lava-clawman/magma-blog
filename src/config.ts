import { defineCollection, z } from 'astro:content';

/**
 * Blog Post Frontmatter Schema
 * 
 * Required fields:
 * - title: The post title
 * - date: Publication date (ISO format)
 * - description: Brief summary for SEO and previews
 * 
 * Optional fields:
 * - tags: Array of topic tags
 * - draft: If true, post won't be published in production
 */
const blog = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    date: z.coerce.date(),
    description: z.string(),
    tags: z.array(z.string()).default([]),
    draft: z.boolean().default(false),
  }),
});

export const collections = {
  blog,
};

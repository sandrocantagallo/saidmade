<?php get_header(); ?>
	<div id="single-page" class="content">
		<?php if (have_posts()) : while (have_posts()) : the_post(); ?>
		<div class="post" id="post-<?php the_ID(); ?>">
			<h2><?php the_title(); ?></h2>
				<div class="entry">
				<?php the_content('<p class="serif">continua &raquo;</p>'); ?>
				<?php wp_link_pages(array('before' => '<p><strong>Pagine: </strong> ', 'after' => '</p>', 'next_or_number' => 'number')); ?>
				</div>
			</div>
		<?php endwhile; endif; ?>
	<?php edit_post_link( 'Modifica', '<p>', '</p>'); ?>
	</div>

<?php get_sidebar(); get_footer(); ?>
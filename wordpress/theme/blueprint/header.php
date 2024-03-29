<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" <?php language_attributes(); ?>>

<head profile="http://gmpg.org/xfn/11">
<meta http-equiv="Content-Type" content="<?php bloginfo('html_type'); ?>; charset=<?php bloginfo('charset'); ?>" />

<title><?php bloginfo('name') ?></title>
<link rel="stylesheet" href="<?php bloginfo('template_url'); ?>/screen.css" type="text/css" media="screen" />
<link rel="stylesheet" href="<?php bloginfo('template_url'); ?>/print.css" type="text/css" media="print">
<link rel="stylesheet" href="<?php bloginfo('stylesheet_url'); ?>" type="text/css" media="screen" />
<!--[if lt IE 8]>
	<link rel="stylesheet" href="<?php bloginfo('template_url'); ?>/ie.css" type="text/css" media="screen" />
<![endif]-->

<link rel="shorcut icon" href="<?php bloginfo('url'); ?>/favicon.ico" type="image/x-ico" />
<link rel="icon" href="<?php bloginfo('url'); ?>/favicon.gif" type="image/gif" />

<script type="text/javascript" src="http://www.google.com/jsapi"></script>
<script type="text/javascript">
	google.load("jquery", "1.3", {uncompessed:false});
	google.load("jqueryui", "1.7", {uncompessed:false});
</script>

<link rel="alternate" type="application/rss+xml" title="<?php printf( '%s RSS Feed', get_bloginfo('name')); ?>" href="<?php bloginfo('rss2_url'); ?>" />
<link rel="alternate" type="application/atom+xml" title="<?php printf( '%s Atom Feed', get_bloginfo('name')); ?>" href="<?php bloginfo('atom_url'); ?>" />
<link rel="pingback" href="<?php bloginfo('pingback_url'); ?>" />

<?php wp_head(); ?>
</head>
<body>
<div id="page">
	<div id="header">
		<div id="headerimg">
			<h1><a href="<?php echo get_option('home'); ?>/"><span><?php bloginfo('name'); ?></span></a></h1>
			<div class="description"><?php bloginfo('description'); ?></div>
		</div>
	</div>
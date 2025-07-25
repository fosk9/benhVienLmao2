<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html class="no-js" lang="zxx">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Health | Template</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico">

    <!-- CSS here -->
    <jsp:include page="common-css.jsp"/>

</head>
<body>
<!--? Preloader Start -->
<div id="preloader-active">
    <div class="preloader d-flex align-items-center justify-content-center">
        <div class="preloader-inner position-relative">
            <div class="preloader-circle"></div>
            <div class="preloader-img pere-text">
                <img src="assets/img/logo/loder.png" alt="">
            </div>
        </div>
    </div>
</div>
<!-- Preloader Start -->
<header>
    <!--? Header Start -->
    <div class="header-area">
        <div class="main-header header-sticky">
            <div class="container-fluid">
                <div class="row align-items-center">
                    <!-- Logo -->
                    <div class="col-xl-2 col-lg-2 col-md-1">
                        <div class="logo">
                            <a href="index.html"><img src="assets/img/logo/logo.png" alt=""></a>
                        </div>
                    </div>
                    <div class="col-xl-10 col-lg-10 col-md-10">
                        <div class="menu-main d-flex align-items-center justify-content-end">
                            <!-- Main-menu -->
                            <div class="main-menu f-right d-none d-lg-block">
                                <nav>
                                    <ul id="navigation">
                                        <li><a href="index.html">Home</a></li>
                                        <li><a href="about.html">About</a></li>
                                        <li><a href="Pact/services.html">Services</a></li>
                                        <li><a href="blog.html">Blog</a>
                                            <ul class="submenu">
                                                <li><a href="blog.html">Blog</a></li>
                                                <li><a href="blog_details.html">Blog Details</a></li>
                                                <li><a href="elements.html">Element</a></li>
                                            </ul>
                                        </li>
                                        <li><a href="contact.html">Contact</a></li>
                                    </ul>
                                </nav>
                            </div>
                            <div class="header-right-btn f-right d-none d-lg-block ml-15">
                                <a href="#" class="btn header-btn">Make an Appointment</a>
                            </div>
                        </div>
                    </div>
                    <!-- Mobile Menu -->
                    <div class="col-12">
                        <div class="mobile_menu d-block d-lg-none"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Header End -->
</header>
<main>
    <!--? Slider Area Start-->
    <div class="slider-area slider-area2">
        <div class="slider-active dot-style">
            <!-- Slider Single -->
            <div class="single-slider  d-flex align-items-center slider-height2">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-xl-7 col-lg-8 col-md-10 ">
                            <div class="hero-wrapper">
                                <div class="hero__caption">
                                    <h1 data-animation="fadeInUp" data-delay=".3s">Element</h1>
                                    <p data-animation="fadeInUp" data-delay=".6s">Almost before we knew it, we<br> had
                                        left the ground</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Slider Area End -->
    <!--? Start Sample Area -->
    <section class="sample-text-area">
        <div class="container box_1170">
            <h3 class="text-heading">Text Sample</h3>
            <p class="sample-text">
                Every avid independent filmmaker has <b>Bold</b> about making that <i>Italic</i> interest documentary,
                or short
                film to show off their creative prowess. Many have great ideas and want to “wow”
                the<sup>Superscript</sup> scene,
                or video renters with their big project. But once you have the<sub>Subscript</sub> “in the can” (no easy
                feat), how
                do you move from a
                <del>Strike</del>
                through of master DVDs with the <u>“Underline”</u> marked
                hand-written title
                inside a secondhand CD case, to a pile of cardboard boxes full of shiny new, retail-ready DVDs, with UPC
                barcodes
                and polywrap sitting on your doorstep? You need to create eye-popping artwork and have your project
                replicated.
                Using a reputable full service DVD Replication company like PacificDisc, Inc. to partner with is
                certainly a
                helpful option to ensure a professional end result, but to help with your DVD replication project, here
                are 4 easy
                steps to follow for good DVD replication results:

            </p>
        </div>
    </section>
    <!-- End Sample Area -->
    <!--? Start Button -->
    <section class="button-area">
        <div class="container box_1170 border-top-generic">
            <h3 class="text-heading">Sample Buttons</h3>
            <div class="button-group-area">
                <a href="#" class="genric-btn default">Default</a>
                <a href="#" class="genric-btn primary">Primary</a>
                <a href="#" class="genric-btn success">Success</a>
                <a href="#" class="genric-btn info">Info</a>
                <a href="#" class="genric-btn warning">Warning</a>
                <a href="#" class="genric-btn danger">Danger</a>
                <a href="#" class="genric-btn link">Link</a>
                <a href="#" class="genric-btn disable">Disable</a>
            </div>
            <div class="button-group-area mt-10">
                <a href="#" class="genric-btn default-border">Default</a>
                <a href="#" class="genric-btn primary-border">Primary</a>
                <a href="#" class="genric-btn success-border">Success</a>
                <a href="#" class="genric-btn info-border">Info</a>
                <a href="#" class="genric-btn warning-border">Warning</a>
                <a href="#" class="genric-btn danger-border">Danger</a>
                <a href="#" class="genric-btn link-border">Link</a>
                <a href="#" class="genric-btn disable">Disable</a>
            </div>
            <div class="button-group-area mt-40">
                <a href="#" class="genric-btn default radius">Default</a>
                <a href="#" class="genric-btn primary radius">Primary</a>
                <a href="#" class="genric-btn success radius">Success</a>
                <a href="#" class="genric-btn info radius">Info</a>
                <a href="#" class="genric-btn warning radius">Warning</a>
                <a href="#" class="genric-btn danger radius">Danger</a>
                <a href="#" class="genric-btn link radius">Link</a>
                <a href="#" class="genric-btn disable radius">Disable</a>
            </div>
            <div class="button-group-area mt-10">
                <a href="#" class="genric-btn default-border radius">Default</a>
                <a href="#" class="genric-btn primary-border radius">Primary</a>
                <a href="#" class="genric-btn success-border radius">Success</a>
                <a href="#" class="genric-btn info-border radius">Info</a>
                <a href="#" class="genric-btn warning-border radius">Warning</a>
                <a href="#" class="genric-btn danger-border radius">Danger</a>
                <a href="#" class="genric-btn link-border radius">Link</a>
                <a href="#" class="genric-btn disable radius">Disable</a>
            </div>
            <div class="button-group-area mt-40">
                <a href="#" class="genric-btn default circle">Default</a>
                <a href="#" class="genric-btn primary circle">Primary</a>
                <a href="#" class="genric-btn success circle">Success</a>
                <a href="#" class="genric-btn info circle">Info</a>
                <a href="#" class="genric-btn warning circle">Warning</a>
                <a href="#" class="genric-btn danger circle">Danger</a>
                <a href="#" class="genric-btn link circle">Link</a>
                <a href="#" class="genric-btn disable circle">Disable</a>
            </div>
            <div class="button-group-area mt-10">
                <a href="#" class="genric-btn default-border circle">Default</a>
                <a href="#" class="genric-btn primary-border circle">Primary</a>
                <a href="#" class="genric-btn success-border circle">Success</a>
                <a href="#" class="genric-btn info-border circle">Info</a>
                <a href="#" class="genric-btn warning-border circle">Warning</a>
                <a href="#" class="genric-btn danger-border circle">Danger</a>
                <a href="#" class="genric-btn link-border circle">Link</a>
                <a href="#" class="genric-btn disable circle">Disable</a>
            </div>
            <div class="button-group-area mt-40">
                <a href="#" class="genric-btn default circle arrow">Default<span class="lnr lnr-arrow-right"></span></a>
                <a href="#" class="genric-btn primary circle arrow">Primary<span class="lnr lnr-arrow-right"></span></a>
                <a href="#" class="genric-btn success circle arrow">Success<span class="lnr lnr-arrow-right"></span></a>
                <a href="#" class="genric-btn info circle arrow">Info<span class="lnr lnr-arrow-right"></span></a>
                <a href="#" class="genric-btn warning circle arrow">Warning<span class="lnr lnr-arrow-right"></span></a>
                <a href="#" class="genric-btn danger circle arrow">Danger<span class="lnr lnr-arrow-right"></span></a>
            </div>
            <div class="button-group-area mt-10">
                <a href="#" class="genric-btn default-border circle arrow">Default<span
                        class="lnr lnr-arrow-right"></span></a>
                <a href="#" class="genric-btn primary-border circle arrow">Primary<span
                        class="lnr lnr-arrow-right"></span></a>
                <a href="#" class="genric-btn success-border circle arrow">Success<span
                        class="lnr lnr-arrow-right"></span></a>
                <a href="#" class="genric-btn info-border circle arrow">Info<span
                        class="lnr lnr-arrow-right"></span></a>
                <a href="#" class="genric-btn warning-border circle arrow">Warning<span
                        class="lnr lnr-arrow-right"></span></a>
                <a href="#" class="genric-btn danger-border circle arrow">Danger<span
                        class="lnr lnr-arrow-right"></span></a>
            </div>
            <div class="button-group-area mt-40">
                <a href="#" class="genric-btn primary e-large">Extra Large</a>
                <a href="#" class="genric-btn success large">Large</a>
                <a href="#" class="genric-btn primary">Default</a>
                <a href="#" class="genric-btn success medium">Medium</a>
                <a href="#" class="genric-btn primary small">Small</a>
            </div>
            <div class="button-group-area mt-10">
                <a href="#" class="genric-btn primary-border e-large">Extra Large</a>
                <a href="#" class="genric-btn success-border large">Large</a>
                <a href="#" class="genric-btn primary-border">Default</a>
                <a href="#" class="genric-btn success-border medium">Medium</a>
                <a href="#" class="genric-btn primary-border small">Small</a>
            </div>
        </div>
    </section>
    <!-- End Button -->
    <!--? Start Align Area -->
    <div class="whole-wrap">
        <div class="container box_1170">
            <div class="section-top-border">
                <h3 class="mb-30">Left Aligned</h3>
                <div class="row">
                    <div class="col-md-3">
                        <img src="assets/img/elements/d.jpg" alt="" class="img-fluid">
                    </div>
                    <div class="col-md-9 mt-sm-20">
                        <p>ABCDEFGH</p>
                    </div>
                </div>
            </div>
            <div class="section-top-border text-right">
                <h3 class="mb-30">Right Aligned</h3>
                <div class="row">
                    <div class="col-md-9">
                        <p class="text-right">ABCDEFGH</p>
                        <p class="text-right">ABCDEFGH</p>
                    </div>
                    <div class="col-md-3">
                        <img src="assets/img/elements/d.jpg" alt="" class="img-fluid">
                    </div>
                </div>
            </div>
            <div class="section-top-border">
                <h3 class="mb-30">Definition</h3>
                <div class="row">
                    <div class="col-md-4">
                        <div class="single-defination">
                            <h4 class="mb-20">Definition 01</h4>
                            <p>ABCDEFGH</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="single-defination">
                            <h4 class="mb-20">Definition 02</h4>
                            <p>ABCDEFGH</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="single-defination">
                            <h4 class="mb-20">Definition 03</h4>
                            <p>ABCDEFGH</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="section-top-border">
                <h3 class="mb-30">Block Quotes</h3>
                <div class="row">
                    <div class="col-lg-12">
                        <blockquote class="generic-blockquote">
                            “ABCDEFGH”
                        </blockquote>
                    </div>
                </div>
            </div>
            <div class="section-top-border">
                <h3 class="mb-30">Table</h3>
                <div class="progress-table-wrap">
                    <div class="progress-table">
                        <div class="table-head">
                            <div class="serial">#</div>
                            <div class="country">Countries</div>
                            <div class="visit">Visits</div>
                            <div class="percentage">Percentages</div>
                        </div>
                        <div class="table-row">
                            <div class="serial">01</div>
                            <div class="country"><img src="assets/img/elements/f1.jpg" alt="flag">Canada</div>
                            <div class="visit">645032</div>
                            <div class="percentage">
                                <div class="progress">
                                    <div class="progress-bar color-1" role="progressbar" style="width: 80%"
                                         aria-valuenow="80" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                        </div>
                        <div class="table-row">
                            <div class="serial">02</div>
                            <div class="country"><img src="assets/img/elements/f2.jpg" alt="flag">Canada</div>
                            <div class="visit">645032</div>
                            <div class="percentage">
                                <div class="progress">
                                    <div class="progress-bar color-2" role="progressbar" style="width: 30%"
                                         aria-valuenow="30" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                        </div>
                        <div class="table-row">
                            <div class="serial">03</div>
                            <div class="country"><img src="assets/img/elements/f3.jpg" alt="flag">Canada</div>
                            <div class="visit">645032</div>
                            <div class="percentage">
                                <div class="progress">
                                    <div class="progress-bar color-3" role="progressbar" style="width: 55%"
                                         aria-valuenow="55" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                        </div>
                        <div class="table-row">
                            <div class="serial">04</div>
                            <div class="country"><img src="assets/img/elements/f4.jpg" alt="flag">Canada</div>
                            <div class="visit">645032</div>
                            <div class="percentage">
                                <div class="progress">
                                    <div class="progress-bar color-4" role="progressbar" style="width: 60%"
                                         aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                        </div>
                        <div class="table-row">
                            <div class="serial">05</div>
                            <div class="country"><img src="assets/img/elements/f5.jpg" alt="flag">Canada</div>
                            <div class="visit">645032</div>
                            <div class="percentage">
                                <div class="progress">
                                    <div class="progress-bar color-5" role="progressbar" style="width: 40%"
                                         aria-valuenow="40" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                        </div>
                        <div class="table-row">
                            <div class="serial">06</div>
                            <div class="country"><img src="assets/img/elements/f6.jpg" alt="flag">Canada</div>
                            <div class="visit">645032</div>
                            <div class="percentage">
                                <div class="progress">
                                    <div class="progress-bar color-6" role="progressbar" style="width: 70%"
                                         aria-valuenow="70" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                        </div>
                        <div class="table-row">
                            <div class="serial">07</div>
                            <div class="country"><img src="assets/img/elements/f7.jpg" alt="flag">Canada</div>
                            <div class="visit">645032</div>
                            <div class="percentage">
                                <div class="progress">
                                    <div class="progress-bar color-7" role="progressbar" style="width: 30%"
                                         aria-valuenow="30" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                        </div>
                        <div class="table-row">
                            <div class="serial">08</div>
                            <div class="country"><img src="assets/img/elements/f8.jpg" alt="flag">Canada</div>
                            <div class="visit">645032</div>
                            <div class="percentage">
                                <div class="progress">
                                    <div class="progress-bar color-8" role="progressbar" style="width: 60%"
                                         aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="section-top-border">
                <h3>Image Gallery</h3>
                <div class="row gallery-item">
                    <div class="col-md-4">
                        <a href="assets/img/elements/g1.jpg" class="img-pop-up">
                            <div class="single-gallery-image"
                                 style="background: url(assets/img/elements/g1.jpg);"></div>
                        </a>
                    </div>
                    <div class="col-md-4">
                        <a href="assets/img/elements/g2.jpg" class="img-pop-up">
                            <div class="single-gallery-image"
                                 style="background: url(assets/img/elements/g2.jpg);"></div>
                        </a>
                    </div>
                    <div class="col-md-4">
                        <a href="assets/img/elements/g3.jpg" class="img-pop-up">
                            <div class="single-gallery-image"
                                 style="background: url(assets/img/elements/g3.jpg);"></div>
                        </a>
                    </div>
                    <div class="col-md-6">
                        <a href="assets/img/elements/g4.jpg" class="img-pop-up">
                            <div class="single-gallery-image"
                                 style="background: url(assets/img/elements/g4.jpg);"></div>
                        </a>
                    </div>
                    <div class="col-md-6">
                        <a href="assets/img/elements/g5.jpg" class="img-pop-up">
                            <div class="single-gallery-image"
                                 style="background: url(assets/img/elements/g5.jpg);"></div>
                        </a>
                    </div>
                    <div class="col-md-4">
                        <a href="assets/img/elements/g6.jpg" class="img-pop-up">
                            <div class="single-gallery-image"
                                 style="background: url(assets/img/elements/g6.jpg);"></div>
                        </a>
                    </div>
                    <div class="col-md-4">
                        <a href="assets/img/elements/g7.jpg" class="img-pop-up">
                            <div class="single-gallery-image"
                                 style="background: url(assets/img/elements/g7.jpg);"></div>
                        </a>
                    </div>
                    <div class="col-md-4">
                        <a href="assets/img/elements/g8.jpg" class="img-pop-up">
                            <div class="single-gallery-image"
                                 style="background: url(assets/img/elements/g8.jpg);"></div>
                        </a>
                    </div>
                </div>
            </div>
            <div class="section-top-border">
                <div class="row">
                    <div class="col-md-4">
                        <h3 class="mb-20">Image Gallery</h3>
                        <div class="typography">
                            <h1>This is header 01</h1>
                            <h2>This is header 02</h2>
                            <h3>This is header 03</h3>
                            <h4>This is header 04</h4>
                            <h5>This is header 01</h5>
                            <h6>This is header 01</h6>
                        </div>
                    </div>
                    <div class="col-md-4 mt-sm-30">
                        <h3 class="mb-20">Unordered List</h3>
                        <div class="">
                            <ul class="unordered-list">
                                <li>Fta Keys</li>
                                <li>For Women Only Your Computer Usage</li>
                                <li>Facts Why Inkjet Printing Is Very Appealing
                                    <ul>
                                        <li>Addiction When Gambling Becomes
                                            <ul>
                                                <li>Protective Preventative Maintenance</li>
                                            </ul>
                                        </li>
                                    </ul>
                                </li>
                                <li>Dealing With Technical Support 10 Useful Tips</li>
                                <li>Make Myspace Your Best Designed Space</li>
                                <li>Cleaning And Organizing Your Computer</li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-md-4 mt-sm-30">
                        <h3 class="mb-20">Ordered List</h3>
                        <div class="">
                            <ol class="ordered-list">
                                <li><span>Fta Keys</span></li>
                                <li><span>For Women Only Your Computer Usage</span></li>
                                <li><span>Facts Why Inkjet Printing Is Very Appealing</span>
                                    <ol class="ordered-list-alpha">
                                        <li><span>Addiction When Gambling Becomes</span>
                                            <ol class="ordered-list-roman">
                                                <li><span>Protective Preventative Maintenance</span></li>
                                            </ol>
                                        </li>
                                    </ol>
                                </li>
                                <li><span>Dealing With Technical Support 10 Useful Tips</span></li>
                                <li><span>Make Myspace Your Best Designed Space</span></li>
                                <li><span>Cleaning And Organizing Your Computer</span></li>
                            </ol>
                        </div>
                    </div>
                </div>
            </div>
            <div class="section-top-border">
                <div class="row">
                    <div class="col-lg-8 col-md-8">
                        <h3 class="mb-30">Form Element</h3>
                        <form action="#">
                            <div class="mt-10">
                                <input type="text" name="first_name" placeholder="First Name"
                                       onfocus="this.placeholder = ''" onblur="this.placeholder = 'First Name'" required
                                       class="single-input">
                            </div>
                            <div class="mt-10">
                                <input type="text" name="last_name" placeholder="Last Name"
                                       onfocus="this.placeholder = ''" onblur="this.placeholder = 'Last Name'" required
                                       class="single-input">
                            </div>
                            <div class="mt-10">
                                <input type="text" name="last_name" placeholder="Last Name"
                                       onfocus="this.placeholder = ''" onblur="this.placeholder = 'Last Name'" required
                                       class="single-input">
                            </div>
                            <div class="mt-10">
                                <input type="email" name="EMAIL" placeholder="Email address"
                                       onfocus="this.placeholder = ''" onblur="this.placeholder = 'Email address'"
                                       required
                                       class="single-input">
                            </div>
                            <div class="input-group-icon mt-10">
                                <div class="icon"><i class="fa fa-thumb-tack" aria-hidden="true"></i></div>
                                <input type="text" name="address" placeholder="Address" onfocus="this.placeholder = ''"
                                       onblur="this.placeholder = 'Address'" required class="single-input">
                            </div>
                            <div class="input-group-icon mt-10">
                                <div class="icon"><i class="fa fa-plane" aria-hidden="true"></i></div>
                                <div class="form-select" id="default-select"
                                ">
                                <select>
                                    <option value=" 1">City</option>
                                    <option value="1">Dhaka</option>
                                    <option value="1">Dilli</option>
                                    <option value="1">Newyork</option>
                                    <option value="1">Islamabad</option>
                                </select>
                            </div>
                    </div>
                    <div class="input-group-icon mt-10">
                        <div class="icon"><i class="fa fa-globe" aria-hidden="true"></i></div>
                        <div class="form-select" id="default-select"
                        ">
                        <select>
                            <option value=" 1">Country</option>
                            <option value="1">Bangladesh</option>
                            <option value="1">India</option>
                            <option value="1">England</option>
                            <option value="1">Srilanka</option>
                        </select>
                    </div>
                </div>

                <div class="mt-10">
															<textarea class="single-textarea" placeholder="Message"
                                                                      onfocus="this.placeholder = ''"
                                                                      onblur="this.placeholder = 'Message'"
                                                                      required></textarea>
                </div>
                <div class="mt-10">
                    <input type="text" name="first_name" placeholder="Primary color"
                           onfocus="this.placeholder = ''" onblur="this.placeholder = 'Primary color'" required
                           class="single-input-primary">
                </div>
                <div class="mt-10">
                    <input type="text" name="first_name" placeholder="Accent color"
                           onfocus="this.placeholder = ''" onblur="this.placeholder = 'Accent color'" required
                           class="single-input-accent">
                </div>
                <div class="mt-10">
                    <input type="text" name="first_name" placeholder="Secondary color"
                           onfocus="this.placeholder = ''" onblur="this.placeholder = 'Secondary color'"
                           required class="single-input-secondary">
                </div>
                </form>
            </div>
            <div class="col-lg-3 col-md-4 mt-sm-30">
                <div class="single-element-widget">
                    <h3 class="mb-30">Switches</h3>
                    <div class="switch-wrap d-flex justify-content-between">
                        <p>01. Sample Switch</p>
                        <div class="primary-switch">
                            <input type="checkbox" id="default-switch">
                            <label for="default-switch"></label>
                        </div>
                    </div>
                    <div class="switch-wrap d-flex justify-content-between">
                        <p>02. Primary Color Switch</p>
                        <div class="primary-switch">
                            <input type="checkbox" id="primary-switch" checked>
                            <label for="primary-switch"></label>
                        </div>
                    </div>
                    <div class="switch-wrap d-flex justify-content-between">
                        <p>03. Confirm Color Switch</p>
                        <div class="confirm-switch">
                            <input type="checkbox" id="confirm-switch" checked>
                            <label for="confirm-switch"></label>
                        </div>
                    </div>
                </div>
                <div class="single-element-widget mt-30">
                    <h3 class="mb-30">Selectboxes</h3>
                    <div class="default-select" id="default-select"
                    ">
                    <select>
                        <option value=" 1">English</option>
                        <option value="1">Spanish</option>
                        <option value="1">Arabic</option>
                        <option value="1">Portuguise</option>
                        <option value="1">Bengali</option>
                    </select>
                </div>
            </div>
            <div class="single-element-widget mt-30">
                <h3 class="mb-30">Checkboxes</h3>
                <div class="switch-wrap d-flex justify-content-between">
                    <p>01. Sample Checkbox</p>
                    <div class="primary-checkbox">
                        <input type="checkbox" id="default-checkbox">
                        <label for="default-checkbox"></label>
                    </div>
                </div>
                <div class="switch-wrap d-flex justify-content-between">
                    <p>02. Primary Color Checkbox</p>
                    <div class="primary-checkbox">
                        <input type="checkbox" id="primary-checkbox" checked>
                        <label for="primary-checkbox"></label>
                    </div>
                </div>
                <div class="switch-wrap d-flex justify-content-between">
                    <p>03. Confirm Color Checkbox</p>
                    <div class="confirm-checkbox">
                        <input type="checkbox" id="confirm-checkbox">
                        <label for="confirm-checkbox"></label>
                    </div>
                </div>
                <div class="switch-wrap d-flex justify-content-between">
                    <p>04. Disabled Checkbox</p>
                    <div class="disabled-checkbox">
                        <input type="checkbox" id="disabled-checkbox" disabled>
                        <label for="disabled-checkbox"></label>
                    </div>
                </div>
                <div class="switch-wrap d-flex justify-content-between">
                    <p>05. Disabled Checkbox active</p>
                    <div class="disabled-checkbox">
                        <input type="checkbox" id="disabled-checkbox-active" checked disabled>
                        <label for="disabled-checkbox-active"></label>
                    </div>
                </div>
            </div>
            <div class="single-element-widget mt-30">
                <h3 class="mb-30">Radios</h3>
                <div class="switch-wrap d-flex justify-content-between">
                    <p>01. Sample radio</p>
                    <div class="primary-radio">
                        <input type="checkbox" id="default-radio">
                        <label for="default-radio"></label>
                    </div>
                </div>
                <div class="switch-wrap d-flex justify-content-between">
                    <p>02. Primary Color radio</p>
                    <div class="primary-radio">
                        <input type="checkbox" id="primary-radio" checked>
                        <label for="primary-radio"></label>
                    </div>
                </div>
                <div class="switch-wrap d-flex justify-content-between">
                    <p>03. Confirm Color radio</p>
                    <div class="confirm-radio">
                        <input type="checkbox" id="confirm-radio" checked>
                        <label for="confirm-radio"></label>
                    </div>
                </div>
                <div class="switch-wrap d-flex justify-content-between">
                    <p>04. Disabled radio</p>
                    <div class="disabled-radio">
                        <input type="checkbox" id="disabled-radio" disabled>
                        <label for="disabled-radio"></label>
                    </div>
                </div>
                <div class="switch-wrap d-flex justify-content-between">
                    <p>05. Disabled radio active</p>
                    <div class="disabled-radio">
                        <input type="checkbox" id="disabled-radio-active" checked disabled>
                        <label for="disabled-radio-active"></label>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>
    </div>
    </div>
    <!-- End Align Area -->
    <!--? About Law Start-->
    <section class="about-low-area mt-100">
        <div class="container">
            <div class="about-cap-wrapper">
                <div class="row">
                    <div class="col-xl-5  col-lg-6 col-md-10 offset-xl-1">
                        <div class="about-caption mb-50">
                            <!-- Section Tittle -->
                            <div class="section-tittle mb-35">
                                <h2>100% satisfaction guaranteed.</h2>
                            </div>
                            <p>Almost before we knew it, we had left the ground</p>
                            <a href="about.html" class="border-btn">Make an Appointment</a>
                        </div>
                    </div>
                    <div class="col-lg-6 col-md-12">
                        <!-- about-img -->
                        <div class="about-img">
                            <div class="about-font-img">
                                <img src="assets/img/gallery/about2.png" alt="">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- About Law End-->
</main>
<footer>
    <div class="footer-wrappr section-bg3" data-background="assets/img/gallery/footer-bg.png">
        <div class="footer-area footer-padding ">
            <div class="container">
                <div class="row justify-content-between">
                    <div class="col-xl-8 col-lg-8 col-md-6 col-sm-12">
                        <div class="single-footer-caption mb-50">
                            <!-- logo -->
                            <div class="footer-logo mb-25">
                                <a href="index.html"><img src="assets/img/logo/logo2_footer.png" alt=""></a>
                            </div>
                            <d iv class="header-area">
                                <div class="main-header main-header2">
                                    <div class="menu-main d-flex align-items-center justify-content-start">
                                        <!-- Main-menu -->
                                        <div class="main-menu main-menu2">
                                            <nav>
                                                <ul>
                                                    <li><a href="index.html">Home</a></li>
                                                    <li><a href="about.html">About</a></li>
                                                    <li><a href="Pact/services.html">Services</a></li>
                                                    <li><a href="blog.html">Blog</a></li>
                                                    <li><a href="contact.html">Contact</a></li>
                                                </ul>
                                            </nav>
                                        </div>
                                    </div>
                                </div>
                            </d>
                            <!-- social -->
                            <div class="footer-social mt-50">
                                <a href="#"><i class="fab fa-twitter"></i></a>
                                <a href="https://bit.ly/sai4ull"><i class="fab fa-facebook-f"></i></a>
                                <a href="#"><i class="fab fa-pinterest-p"></i></a>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-4 col-lg-4 col-md-6 col-sm-12">
                        <div class="single-footer-caption">
                            <div class="footer-tittle mb-50">
                                <h4>Subscribe newsletter</h4>
                            </div>
                            <!-- Form -->
                            <div class="footer-form">
                                <div id="mc_embed_signup">
                                    <form target="_blank"
                                          action="https://spondonit.us12.list-manage.com/subscribe/post?u=1462626880ade1ac87bd9c93a&amp;id=92a4423d01"
                                          method="get" class="subscribe_form relative mail_part" novalidate="true">
                                        <input type="email" name="EMAIL" id="newsletter-form-email"
                                               placeholder=" Email Address " class="placeholder hide-on-focus"
                                               onfocus="this.placeholder = ''"
                                               onblur="this.placeholder = 'Enter your email'">
                                        <div class="form-icon">
                                            <button type="submit" name="submit" id="newsletter-submit"
                                                    class="email_icon newsletter-submit button-contactForm">
                                                Subscribe
                                            </button>
                                        </div>
                                        <div class="mt-10 info"></div>
                                    </form>
                                </div>
                            </div>
                            <div class="footer-tittle">
                                <div class="footer-pera">
                                    <p>Praesent porttitor, nulla vitae posuere iaculis, arcu nisl dignissim dolor, a
                                        pretium misem ut ipsum.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- footer-bottom area -->
        <div class="footer-bottom-area">
            <div class="container">
                <div class="footer-border">
                    <div class="row">
                        <div class="col-xl-10 ">
                            <div class="footer-copy-right">
                                <p>
                                    <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
                                    Copyright &copy;<script>document.write(new Date().getFullYear());</script>
                                    All rights reserved | This template is made with <i class="fa fa-heart"
                                                                                        aria-hidden="true"></i> by <a
                                        href="https://colorlib.com" target="_blank">Colorlib</a>
                                    <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</footer>
<!-- Scroll Up -->
<div id="back-top">
    <a title="Go to Top" href="#"> <i class="fas fa-level-up-alt"></i></a>
</div>

</p>
</div>
</section>
<!-- End Sample Area -->

<!-- JS here -->
<jsp:include page="common-scripts.jsp"/>

</body>
</html>
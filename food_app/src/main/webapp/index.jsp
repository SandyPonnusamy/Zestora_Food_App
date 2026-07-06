<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Zestora — Food Delivery</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Archivo+Black&family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>

/* ============================================================
   RESET & ROOT
============================================================ */
:root{
  --ink:#2B1B17;
  --paper:#FFF7EC;
  --card:#FFFFFF;
  --chili:#FF4D3D;
  --chili-dark:#E0331F;
  --gold:#FFB627;
  --teal:#1B998B;
  --line:rgba(43,27,23,0.10);
  --muted:rgba(43,27,23,0.6);
  --shadow:0 14px 30px rgba(43,27,23,0.10);
  --shadow-lg:0 24px 60px rgba(43,27,23,0.18);
}
*{ box-sizing:border-box; margin:0; padding:0; }
html{ scroll-behavior:smooth; }
body{
  background:var(--paper);
  color:var(--ink);
  font-family:'Inter',sans-serif;
  -webkit-font-smoothing:antialiased;
  overflow-x:hidden;
}
a{ color:inherit; text-decoration:none; }
img{ max-width:100%; display:block; }
ul{ list-style:none; }

/* ============================================================
   NAVBAR
============================================================ */
.navbar{
  position:fixed;
  top:0; left:0; right:0;
  z-index:200;
  display:flex;
  align-items:center;
  justify-content:space-between;
  padding:18px 60px;
  background:transparent;
  transition:background .4s ease, padding .4s ease, box-shadow .4s ease;
}
/* Scrolled state via :has — supported in all modern browsers */
body:has(.hero-anchor:not(:is(:hover))):not(:has(.hero-anchor:nth-child(1))) .navbar,
.navbar.scrolled{
  background:var(--ink);
  padding:12px 60px;
  box-shadow:0 4px 24px rgba(0,0,0,0.25);
}
/* Simpler: always dark after hero using position trick */
.navbar{ background: rgba(0,0,0,0.15); backdrop-filter:blur(8px); }

.logo{
  font-family:'Archivo Black',sans-serif;
  font-size:1.65rem;
  color:#fff;
  letter-spacing:-0.02em;
}
.logo .dot{ color:var(--gold); }
.logo .tagline{
  font-family:'Inter',sans-serif;
  font-size:0.65rem;
  font-weight:600;
  letter-spacing:0.1em;
  text-transform:uppercase;
  color:rgba(255,255,255,0.6);
  display:block;
  margin-top:-4px;
}

.nav-links{
  display:flex;
  align-items:center;
  gap:32px;
}
.nav-links a{
  color:rgba(255,255,255,0.88);
  font-weight:600;
  font-size:0.92rem;
  position:relative;
}
.nav-links a::after{
  content:"";
  position:absolute;
  bottom:-3px; left:0;
  width:0; height:2px;
  background:var(--gold);
  transition:width .25s ease;
}
.nav-links a:hover::after{ width:100%; }
.nav-links a:hover{ color:#fff; }
.nav-cta{
  background:var(--chili);
  color:#fff !important;
  padding:10px 22px;
  border-radius:999px;
  font-weight:700;
  font-size:0.88rem;
  box-shadow:0 6px 20px rgba(255,77,61,0.4);
  transition:background .2s ease, transform .2s ease, box-shadow .2s ease;
}
.nav-cta:hover{
  background:var(--chili-dark) !important;
  transform:translateY(-2px);
  box-shadow:0 10px 28px rgba(255,77,61,0.5);
}
.nav-cta::after{ display:none !important; }

/* ============================================================
   HERO
============================================================ */
.hero{
  position:relative;
  height:100vh;
  min-height:600px;
  display:flex;
  align-items:center;
  justify-content:center;
  overflow:hidden;
  text-align:center;
}
.hero-video-wrap{
  position:absolute;
  inset:0;
  z-index:0;
}
.hero-video-wrap video{
  width:100%; height:100%;
  object-fit:cover;
}
/* Fallback gradient when video doesn't load */
.hero-video-wrap::before{
  content:"";
  position:absolute;
  inset:0;
  background: linear-gradient(135deg,
    #1a0a06 0%,
    #3d1a10 30%,
    #c0281a 70%,
    #1a0a06 100%);
  z-index:0;
}
.hero-video-wrap::after{
  content:"";
  position:absolute;
  inset:0;
  background:linear-gradient(
    to bottom,
    rgba(0,0,0,0.3) 0%,
    rgba(0,0,0,0.1) 40%,
    rgba(0,0,0,0.55) 100%
  );
  z-index:1;
}
.hero-content{
  position:relative;
  z-index:10;
  max-width:820px;
  padding:0 24px;
  /* CSS entrance animation — no JS */
  animation:heroFadeUp 1.1s cubic-bezier(.22,1,.36,1) both;
}
@keyframes heroFadeUp{
  from{ opacity:0; transform:translateY(40px); }
  to{ opacity:1; transform:translateY(0); }
}
.hero-eyebrow{
  display:inline-flex;
  align-items:center;
  gap:8px;
  background:rgba(255,182,39,0.18);
  border:1px solid rgba(255,182,39,0.35);
  color:var(--gold);
  font-size:0.78rem;
  font-weight:700;
  text-transform:uppercase;
  letter-spacing:0.08em;
  padding:6px 14px;
  border-radius:999px;
  margin-bottom:22px;
  animation:heroFadeUp 1.1s .1s cubic-bezier(.22,1,.36,1) both;
}
.hero-eyebrow::before{ content:"🍽"; font-size:0.9rem; }
.hero-title{
  font-family:'Archivo Black',sans-serif;
  font-size:clamp(2.6rem, 7vw, 5.2rem);
  color:#fff;
  line-height:1.08;
  letter-spacing:-0.02em;
  margin-bottom:20px;
  animation:heroFadeUp 1.1s .2s cubic-bezier(.22,1,.36,1) both;
}
.hero-title em{
  font-style:normal;
  color:var(--gold);
  position:relative;
}
.hero-title em::after{
  content:"";
  position:absolute;
  bottom:-4px; left:0; right:0;
  height:4px;
  background:var(--gold);
  border-radius:2px;
  opacity:0.6;
}
.hero-sub{
  font-size:clamp(1rem,2vw,1.2rem);
  color:rgba(255,255,255,0.82);
  line-height:1.6;
  margin-bottom:36px;
  animation:heroFadeUp 1.1s .3s cubic-bezier(.22,1,.36,1) both;
}
.hero-actions{
  display:flex;
  align-items:center;
  justify-content:center;
  gap:14px;
  flex-wrap:wrap;
  animation:heroFadeUp 1.1s .4s cubic-bezier(.22,1,.36,1) both;
}
.btn-hero-primary{
  background:var(--chili);
  color:#fff;
  font-weight:800;
  font-size:1rem;
  padding:16px 36px;
  border-radius:999px;
  box-shadow:0 10px 32px rgba(255,77,61,0.45);
  transition:background .2s ease, transform .2s ease, box-shadow .2s ease;
  display:inline-flex;
  align-items:center;
  gap:8px;
}
.btn-hero-primary:hover{
  background:var(--chili-dark);
  transform:translateY(-3px);
  box-shadow:0 16px 40px rgba(255,77,61,0.55);
}
.btn-hero-secondary{
  background:rgba(255,255,255,0.12);
  color:#fff;
  font-weight:700;
  font-size:0.96rem;
  padding:16px 32px;
  border-radius:999px;
  border:1.5px solid rgba(255,255,255,0.3);
  backdrop-filter:blur(6px);
  transition:background .2s ease, transform .2s ease;
  display:inline-flex;
  align-items:center;
  gap:8px;
}
.btn-hero-secondary:hover{
  background:rgba(255,255,255,0.22);
  transform:translateY(-2px);
}

/* Floating food bubbles — pure CSS */
.hero-bubble{
  position:absolute;
  border-radius:50%;
  background:rgba(255,255,255,0.06);
  border:1px solid rgba(255,255,255,0.1);
  backdrop-filter:blur(4px);
  display:flex;
  align-items:center;
  justify-content:center;
  font-size:2rem;
  animation:float 6s ease-in-out infinite;
  z-index:5;
}
.hero-bubble:nth-child(1){ width:80px;height:80px; top:18%;left:8%; animation-delay:0s; }
.hero-bubble:nth-child(2){ width:60px;height:60px; top:30%;right:10%; animation-delay:1s; }
.hero-bubble:nth-child(3){ width:70px;height:70px; bottom:25%;left:12%; animation-delay:2s; }
.hero-bubble:nth-child(4){ width:55px;height:55px; bottom:30%;right:8%; animation-delay:.5s; }
.hero-bubble:nth-child(5){ width:65px;height:65px; top:12%;right:22%; animation-delay:1.5s; }

@keyframes float{
  0%,100%{ transform:translateY(0) rotate(0deg); }
  33%{ transform:translateY(-18px) rotate(4deg); }
  66%{ transform:translateY(-8px) rotate(-3deg); }
}

/* Scroll hint */
.scroll-hint{
  position:absolute;
  bottom:32px;
  left:50%;
  transform:translateX(-50%);
  z-index:10;
  display:flex;
  flex-direction:column;
  align-items:center;
  gap:8px;
  color:rgba(255,255,255,0.6);
  font-size:0.72rem;
  font-weight:600;
  letter-spacing:0.06em;
  text-transform:uppercase;
  animation:heroFadeUp 1.1s .8s cubic-bezier(.22,1,.36,1) both;
}
.scroll-mouse{
  width:24px; height:38px;
  border:2px solid rgba(255,255,255,0.4);
  border-radius:12px;
  display:flex;
  justify-content:center;
  padding-top:6px;
}
.scroll-mouse::after{
  content:"";
  width:3px; height:8px;
  background:rgba(255,255,255,0.6);
  border-radius:2px;
  animation:scrollDot 2s ease-in-out infinite;
}
@keyframes scrollDot{
  0%,100%{ transform:translateY(0); opacity:1; }
  80%{ transform:translateY(10px); opacity:0; }
}

/* ============================================================
   TRUST BAR
============================================================ */
.trust-bar{
  background:var(--ink);
  padding:18px 60px;
  display:flex;
  align-items:center;
  justify-content:center;
  gap:48px;
  flex-wrap:wrap;
}
.trust-item{
  display:flex;
  align-items:center;
  gap:10px;
  color:rgba(255,247,236,0.75);
  font-size:0.84rem;
  font-weight:600;
}
.trust-item span.num{
  font-family:'Archivo Black',sans-serif;
  font-size:1.1rem;
  color:var(--gold);
}

/* ============================================================
   SECTION SHARED
============================================================ */
section{ padding:96px 60px; }
.section-eyebrow{
  display:inline-flex;
  align-items:center;
  gap:8px;
  font-size:0.76rem;
  font-weight:700;
  text-transform:uppercase;
  letter-spacing:0.1em;
  color:var(--chili);
  margin-bottom:14px;
}
.section-eyebrow::before{
  content:"";
  width:22px; height:2px;
  background:var(--chili);
  border-radius:2px;
}
.section-title{
  font-family:'Archivo Black',sans-serif;
  font-size:clamp(1.8rem,3.5vw,2.8rem);
  line-height:1.12;
  letter-spacing:-0.02em;
  margin-bottom:16px;
}
.section-sub{
  font-size:1.05rem;
  color:var(--muted);
  line-height:1.6;
  max-width:540px;
}
.center{ text-align:center; }
.center .section-sub{ margin:0 auto; }

/* ============================================================
   HOW IT WORKS
============================================================ */
.how-section{
  background:var(--card);
}
.steps-grid{
  display:grid;
  grid-template-columns:repeat(4,1fr);
  gap:32px;
  margin-top:56px;
  position:relative;
}
.steps-grid::before{
  content:"";
  position:absolute;
  top:40px; left:calc(12.5% + 16px); right:calc(12.5% + 16px);
  height:2px;
  background:repeating-linear-gradient(
    90deg, var(--chili) 0, var(--chili) 12px, transparent 12px, transparent 24px
  );
  z-index:0;
}
.step-card{
  text-align:center;
  position:relative;
  z-index:1;
}
.step-icon{
  width:80px; height:80px;
  border-radius:50%;
  background:linear-gradient(135deg, rgba(255,77,61,0.12), rgba(255,182,39,0.12));
  border:2px solid rgba(255,77,61,0.15);
  display:flex;
  align-items:center;
  justify-content:center;
  margin:0 auto 18px;
  font-size:2rem;
  transition:transform .3s ease, box-shadow .3s ease, background .3s ease;
}
.step-card:hover .step-icon{
  transform:scale(1.12) translateY(-4px);
  box-shadow:0 12px 28px rgba(255,77,61,0.25);
  background:linear-gradient(135deg, rgba(255,77,61,0.2), rgba(255,182,39,0.2));
}
.step-num{
  position:absolute;
  top:-4px; right:calc(50% - 48px);
  width:22px; height:22px;
  background:var(--chili);
  color:#fff;
  font-size:0.68rem;
  font-weight:800;
  border-radius:50%;
  display:flex;
  align-items:center;
  justify-content:center;
}
.step-card h3{
  font-family:'Archivo Black',sans-serif;
  font-size:1rem;
  margin-bottom:8px;
}
.step-card p{
  font-size:0.84rem;
  color:var(--muted);
  line-height:1.6;
}

/* ============================================================
   CATEGORIES
============================================================ */
.categories-section{ background:var(--paper); }
.cat-scroll{
  display:grid;
  grid-template-columns:repeat(6,1fr);
  gap:20px;
  margin-top:48px;
}
.cat-card{
  background:var(--card);
  border:1px solid var(--line);
  border-radius:20px;
  padding:28px 16px 22px;
  text-align:center;
  cursor:pointer;
  transition:transform .25s ease, box-shadow .25s ease, border-color .25s ease;
  box-shadow:var(--shadow);
  position:relative;
  overflow:hidden;
}
.cat-card::before{
  content:"";
  position:absolute;
  inset:0;
  background:linear-gradient(135deg, rgba(255,77,61,0.06), rgba(255,182,39,0.06));
  opacity:0;
  transition:opacity .25s ease;
}
.cat-card:hover{
  transform:translateY(-8px);
  box-shadow:0 20px 40px rgba(43,27,23,0.16);
  border-color:var(--chili);
}
.cat-card:hover::before{ opacity:1; }
.cat-emoji{
  font-size:2.6rem;
  margin-bottom:12px;
  display:block;
  transition:transform .3s ease;
}
.cat-card:hover .cat-emoji{ transform:scale(1.18) rotate(-5deg); }
.cat-card h4{
  font-family:'Archivo Black',sans-serif;
  font-size:0.86rem;
  margin-bottom:4px;
}
.cat-card span{
  font-size:0.72rem;
  color:var(--muted);
  font-weight:500;
}

/* ============================================================
   FEATURED RESTAURANTS
============================================================ */
.restaurants-section{ background:var(--card); }
.resto-grid{
  display:grid;
  grid-template-columns:repeat(3,1fr);
  gap:24px;
  margin-top:48px;
}
.resto-card{
  border-radius:18px;
  overflow:hidden;
  background:var(--paper);
  border:1px solid var(--line);
  box-shadow:var(--shadow);
  transition:transform .3s ease, box-shadow .3s ease;
  cursor:pointer;
}
.resto-card:hover{
  transform:translateY(-6px);
  box-shadow:var(--shadow-lg);
}
.resto-img{
  position:relative;
  aspect-ratio:16/9;
  overflow:hidden;
}
.resto-img img{
  width:100%; height:100%;
  object-fit:cover;
  transition:transform .5s ease;
}
.resto-card:hover .resto-img img{ transform:scale(1.07); }
.resto-badge{
  position:absolute;
  top:12px; left:12px;
  background:var(--gold);
  color:var(--ink);
  font-size:0.68rem;
  font-weight:800;
  text-transform:uppercase;
  letter-spacing:0.03em;
  padding:4px 10px;
  border-radius:999px;
}
.resto-badge.offer{ background:var(--teal); color:#fff; }
.resto-time{
  position:absolute;
  bottom:12px; right:12px;
  background:rgba(0,0,0,0.7);
  color:#fff;
  font-size:0.72rem;
  font-weight:700;
  padding:4px 10px;
  border-radius:6px;
  backdrop-filter:blur(4px);
}
.resto-body{ padding:16px 18px 18px; }
.resto-body-top{
  display:flex;
  justify-content:space-between;
  align-items:flex-start;
  margin-bottom:6px;
}
.resto-name{
  font-family:'Archivo Black',sans-serif;
  font-size:1rem;
}
.resto-rating{
  background:var(--teal);
  color:#fff;
  font-size:0.76rem;
  font-weight:700;
  padding:3px 9px;
  border-radius:6px;
  display:flex;
  align-items:center;
  gap:3px;
  flex-shrink:0;
}
.resto-rating::before{ content:"★"; }
.resto-meta{
  font-size:0.8rem;
  color:var(--muted);
  display:flex;
  gap:10px;
  align-items:center;
  flex-wrap:wrap;
}
.resto-meta .dot-sep::before{ content:"·"; margin-right:10px; }

/* ============================================================
   PARALLAX BANNER (CSS only)
============================================================ */
.parallax-section{
  position:relative;
  height:480px;
  overflow:hidden;
  display:flex;
  align-items:center;
  justify-content:center;
}
.parallax-bg{
  position:absolute;
  inset:-20% 0;
  background:
    linear-gradient(135deg, rgba(43,27,23,0.88) 0%, rgba(224,51,31,0.75) 100%),
    url('https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=1600&h=900&fit=crop') center/cover no-repeat;
  /* CSS parallax: element is taller than viewport and positioned to simulate parallax */
  transform:translateZ(0);
  will-change:transform;
}
/* Pure CSS parallax using scroll-driven animation — Chrome 115+, Firefox 110+ */
@supports (animation-timeline: scroll()) {
  .parallax-bg{
    animation: parallaxMove linear both;
    animation-timeline: scroll(root block);
    animation-range: 0% 100%;
  }
  @keyframes parallaxMove{
    from{ transform: translateY(-10%); }
    to{ transform: translateY(10%); }
  }
}
.parallax-content{
  position:relative;
  z-index:10;
  text-align:center;
  color:#fff;
  padding:0 24px;
}
.parallax-content h2{
  font-family:'Archivo Black',sans-serif;
  font-size:clamp(2rem,5vw,3.6rem);
  line-height:1.1;
  letter-spacing:-0.02em;
  margin-bottom:16px;
}
.parallax-content h2 em{ font-style:normal; color:var(--gold); }
.parallax-content p{
  font-size:1.08rem;
  color:rgba(255,255,255,0.82);
  margin-bottom:32px;
}
.parallax-actions{
  display:flex;
  gap:14px;
  justify-content:center;
  flex-wrap:wrap;
}

/* ============================================================
   FEATURES / WHY US
============================================================ */
.features-section{
  background:var(--paper);
}
.features-grid{
  display:grid;
  grid-template-columns:1fr 1fr;
  gap:60px;
  align-items:center;
  margin-top:0;
}
.features-visual{
  position:relative;
  border-radius:24px;
  overflow:hidden;
  aspect-ratio:4/3;
}
.features-visual img{
  width:100%; height:100%;
  object-fit:cover;
  transition:transform .6s ease;
}
.features-visual:hover img{ transform:scale(1.04); }
.features-visual::after{
  content:"";
  position:absolute;
  inset:0;
  background:linear-gradient(135deg, rgba(255,77,61,0.15), transparent 60%);
}
.features-float{
  position:absolute;
  bottom:20px; left:20px;
  background:rgba(255,255,255,0.95);
  backdrop-filter:blur(8px);
  border-radius:14px;
  padding:14px 18px;
  box-shadow:0 8px 24px rgba(0,0,0,0.18);
  z-index:5;
  min-width:200px;
}
.features-float .float-label{
  font-size:0.72rem;
  color:var(--muted);
  font-weight:600;
  text-transform:uppercase;
  letter-spacing:0.04em;
  margin-bottom:4px;
}
.features-float .float-val{
  font-family:'Archivo Black',sans-serif;
  font-size:1.1rem;
  color:var(--ink);
}
.features-float .float-sub{
  font-size:0.76rem;
  color:var(--teal);
  font-weight:700;
  margin-top:2px;
}
.feature-list{
  display:flex;
  flex-direction:column;
  gap:24px;
  margin-top:40px;
}
.feature-item{
  display:flex;
  gap:16px;
  align-items:flex-start;
}
.feature-icon{
  width:48px; height:48px;
  border-radius:14px;
  background:linear-gradient(135deg, rgba(255,77,61,0.12), rgba(255,182,39,0.1));
  border:1px solid rgba(255,77,61,0.15);
  display:flex;
  align-items:center;
  justify-content:center;
  font-size:1.4rem;
  flex-shrink:0;
  transition:transform .25s ease;
}
.feature-item:hover .feature-icon{ transform:rotate(-6deg) scale(1.1); }
.feature-item h4{
  font-family:'Archivo Black',sans-serif;
  font-size:0.96rem;
  margin-bottom:4px;
}
.feature-item p{ font-size:0.84rem; color:var(--muted); line-height:1.5; }

/* ============================================================
   TESTIMONIALS
============================================================ */
.testimonials-section{
  background:var(--ink);
  color:var(--paper);
}
.testimonials-section .section-eyebrow{ color:var(--gold); }
.testimonials-section .section-eyebrow::before{ background:var(--gold); }
.testimonials-section .section-sub{ color:rgba(255,247,236,0.65); }
.testimonials-grid{
  display:grid;
  grid-template-columns:repeat(3,1fr);
  gap:24px;
  margin-top:48px;
}
.testi-card{
  background:rgba(255,247,236,0.05);
  border:1px solid rgba(255,247,236,0.1);
  border-radius:18px;
  padding:26px 24px;
  transition:background .25s ease, transform .25s ease;
}
.testi-card:hover{
  background:rgba(255,247,236,0.09);
  transform:translateY(-4px);
}
.testi-stars{
  color:var(--gold);
  font-size:0.9rem;
  letter-spacing:2px;
  margin-bottom:14px;
}
.testi-text{
  font-size:0.92rem;
  line-height:1.65;
  color:rgba(255,247,236,0.82);
  margin-bottom:20px;
  font-style:italic;
}
.testi-author{
  display:flex;
  align-items:center;
  gap:12px;
}
.testi-avatar{
  width:42px; height:42px;
  border-radius:50%;
  object-fit:cover;
  border:2px solid rgba(255,182,39,0.3);
}
.testi-name{
  font-family:'Archivo Black',sans-serif;
  font-size:0.88rem;
}
.testi-loc{
  font-size:0.74rem;
  color:rgba(255,247,236,0.5);
  margin-top:1px;
}

/* ============================================================
   APP DOWNLOAD BANNER
============================================================ */
.app-section{
  background:linear-gradient(135deg, var(--ink) 0%, #45291f 50%, var(--chili-dark) 120%);
  color:#fff;
  text-align:center;
  padding:96px 60px;
  position:relative;
  overflow:hidden;
}
.app-section::before{
  content:"";
  position:absolute;
  top:-80px; right:-80px;
  width:400px; height:400px;
  background:radial-gradient(circle, rgba(255,182,39,0.2), transparent 70%);
}
.app-section::after{
  content:"";
  position:absolute;
  bottom:-60px; left:-60px;
  width:300px; height:300px;
  background:radial-gradient(circle, rgba(255,77,61,0.2), transparent 70%);
}
.app-section .section-title{ color:#fff; }
.app-section .section-sub{ color:rgba(255,255,255,0.7); margin:0 auto 36px; }
.app-badges{
  display:flex;
  gap:16px;
  justify-content:center;
  flex-wrap:wrap;
  position:relative;
  z-index:2;
}
.app-badge{
  display:flex;
  align-items:center;
  gap:10px;
  background:rgba(255,255,255,0.1);
  border:1.5px solid rgba(255,255,255,0.2);
  backdrop-filter:blur(6px);
  padding:12px 22px;
  border-radius:14px;
  transition:background .2s ease, transform .2s ease;
}
.app-badge:hover{
  background:rgba(255,255,255,0.18);
  transform:translateY(-3px);
}
.app-badge svg{ width:28px; height:28px; color:#fff; }
.app-badge-text{ text-align:left; }
.app-badge-text .small{ font-size:0.68rem; color:rgba(255,255,255,0.65); font-weight:500; }
.app-badge-text .big{ font-size:0.96rem; font-weight:700; color:#fff; }

/* ============================================================
   FOOTER
============================================================ */
footer{
  background:var(--ink);
  color:rgba(255,247,236,0.7);
  padding:56px 60px 32px;
}
.footer-grid{
  display:grid;
  grid-template-columns:2fr 1fr 1fr 1fr;
  gap:48px;
  margin-bottom:48px;
}
.footer-brand .logo{ color:#fff; font-size:1.4rem; display:inline-block; margin-bottom:14px; }
.footer-brand p{
  font-size:0.84rem;
  line-height:1.6;
  color:rgba(255,247,236,0.55);
  max-width:260px;
}
.footer-col h5{
  font-family:'Archivo Black',sans-serif;
  font-size:0.82rem;
  color:#fff;
  text-transform:uppercase;
  letter-spacing:0.06em;
  margin-bottom:16px;
}
.footer-col ul li{
  margin-bottom:10px;
}
.footer-col ul li a{
  font-size:0.84rem;
  color:rgba(255,247,236,0.55);
  transition:color .2s ease;
}
.footer-col ul li a:hover{ color:var(--gold); }
.footer-bottom{
  border-top:1px solid rgba(255,247,236,0.1);
  padding-top:24px;
  display:flex;
  align-items:center;
  justify-content:space-between;
  font-size:0.78rem;
  color:rgba(255,247,236,0.4);
  flex-wrap:wrap;
  gap:12px;
}
.footer-socials{
  display:flex;
  gap:12px;
}
.footer-socials a{
  width:34px; height:34px;
  border-radius:50%;
  background:rgba(255,247,236,0.07);
  display:flex;
  align-items:center;
  justify-content:center;
  font-size:0.8rem;
  color:rgba(255,247,236,0.6);
  transition:background .2s ease, color .2s ease;
}
.footer-socials a:hover{ background:var(--chili); color:#fff; }

/* ============================================================
   RESPONSIVE
============================================================ */
@media(max-width:1100px){
  .cat-scroll{ grid-template-columns:repeat(3,1fr); }
  .resto-grid{ grid-template-columns:repeat(2,1fr); }
  .steps-grid{ grid-template-columns:repeat(2,1fr); }
  .steps-grid::before{ display:none; }
  .features-grid{ gap:40px; }
  .footer-grid{ grid-template-columns:1fr 1fr; gap:36px; }
}
@media(max-width:860px){
  section{ padding:72px 32px; }
  .navbar{ padding:16px 32px; }
  .trust-bar{ padding:16px 32px; gap:28px; }
  .features-grid{ grid-template-columns:1fr; }
  .features-visual{ max-width:520px; margin:0 auto; }
  .testimonials-grid{ grid-template-columns:1fr; }
  .app-section{ padding:72px 32px; }
  footer{ padding:48px 32px 28px; }
}
@media(max-width:600px){
  section{ padding:56px 20px; }
  .navbar{ padding:14px 20px; }
  .trust-bar{ padding:14px 20px; gap:20px; }
  .cat-scroll{ grid-template-columns:repeat(2,1fr); gap:14px; }
  .resto-grid{ grid-template-columns:1fr; }
  .steps-grid{ grid-template-columns:1fr; gap:24px; }
  .hero-bubble{ display:none; }
  .parallax-section{ height:360px; }
  footer{ padding:40px 20px 24px; }
  .footer-grid{ grid-template-columns:1fr; gap:28px; }
  .footer-bottom{ flex-direction:column; align-items:flex-start; }
}
@media(prefers-reduced-motion:reduce){ *{ animation:none !important; transition:none !important; } }
</style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
  <a href="index.jsp" class="logo">
    Zest<span class="dot">ora</span>
    <span class="tagline">Food Delivery</span>
  </a>
  <ul class="nav-links">
    <li><a href="#how">How it works</a></li>
    <li><a href="#restaurants">Restaurants</a></li>
    <li><a href="login.jsp">Login</a></li>
    <li><a href="register.html" class="nav-cta">Order Now</a></li>
  </ul>
</nav>

<!-- HERO -->
<section class="hero" id="home">
  <div class="hero-video-wrap">
    <!-- Video background: replace src with your own if available -->
    <video autoplay muted loop playsinline poster="https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=1600&h=900&fit=crop">
      <source src="" type="video/mp4">
      <!-- Poster image shows as fallback when video is unavailable -->
    </video>
  </div>

  <!-- Floating food bubbles — pure CSS animation -->
  <div class="hero-bubble">🍛</div>
  <div class="hero-bubble">🍕</div>
  <div class="hero-bubble">🍔</div>
  <div class="hero-bubble">🥗</div>
  <div class="hero-bubble">🍜</div>

  <div class="hero-content">
    <div class="hero-eyebrow">Now delivering in Bangalore</div>
    <h1 class="hero-title">
      Great food,<br>
      delivered <em>fast</em>
    </h1>
    <p class="hero-sub">
      Order from 500+ restaurants near you.<br>
      Fresh meals at your door in under 30 minutes.
    </p>
    <div class="hero-actions">
      <a href="callRestaurantServlet" class="btn-hero-primary">
        🍽 Explore restaurants
      </a>
      <a href="register.html" class="btn-hero-secondary">
        Sign up free →
      </a>
    </div>
  </div>

  <div class="scroll-hint">
    <div class="scroll-mouse"></div>
    Scroll
  </div>
</section>

<!-- TRUST BAR -->
<div class="trust-bar">
  <div class="trust-item"><span class="num">500+</span> Restaurants</div>
  <div class="trust-item"><span class="num">30</span> Min avg delivery</div>
  <div class="trust-item"><span class="num">50K+</span> Happy customers</div>
  <div class="trust-item"><span class="num">4.8★</span> App rating</div>
  <div class="trust-item"><span class="num">24/7</span> Support</div>
</div>

<!-- HOW IT WORKS -->
<section class="how-section" id="how">
  <div class="center">
    <div class="section-eyebrow">Simple & Fast</div>
    <h2 class="section-title">How Zestora works</h2>
    <p class="section-sub">From craving to doorstep in four easy steps.</p>
  </div>
  <div class="steps-grid">
    <div class="step-card">
      <div class="step-icon">📍<span class="step-num">1</span></div>
      <h3>Set your location</h3>
      <p>Tell us where you are and we show you the best restaurants nearby.</p>
    </div>
    <div class="step-card">
      <div class="step-icon">🍽<span class="step-num">2</span></div>
      <h3>Browse & pick</h3>
      <p>Explore hundreds of menus, filter by cuisine or rating, add to cart.</p>
    </div>
    <div class="step-card">
      <div class="step-icon">💳<span class="step-num">3</span></div>
      <h3>Pay securely</h3>
      <p>UPI, card, or cash on delivery — choose what works best for you.</p>
    </div>
    <div class="step-card">
      <div class="step-icon">🚴<span class="step-num">4</span></div>
      <h3>Fast delivery</h3>
      <p>Our agents pick up and deliver your order hot and fresh to your door.</p>
    </div>
  </div>
</section>

<!-- CATEGORIES -->
<section class="categories-section">
  <div class="center">
    <div class="section-eyebrow">What are you craving?</div>
    <h2 class="section-title">Order by cuisine</h2>
    <p class="section-sub">From biryani to burgers, find exactly what you're in the mood for.</p>
  </div>
  <div class="cat-scroll">
    <a href="callRestaurantServlet" class="cat-card">
      <span class="cat-emoji">🍛</span>
      <h4>Indian</h4>
      <span>120+ places</span>
    </a>
    <a href="callRestaurantServlet" class="cat-card">
      <span class="cat-emoji">🍕</span>
      <h4>Italian</h4>
      <span>48+ places</span>
    </a>
    <a href="callRestaurantServlet" class="cat-card">
      <span class="cat-emoji">🍔</span>
      <h4>Fast Food</h4>
      <span>86+ places</span>
    </a>
    <a href="callRestaurantServlet" class="cat-card">
      <span class="cat-emoji">🥗</span>
      <h4>Healthy</h4>
      <span>34+ places</span>
    </a>
    <a href="callRestaurantServlet" class="cat-card">
      <span class="cat-emoji">🍜</span>
      <h4>Chinese</h4>
      <span>62+ places</span>
    </a>
    <a href="callRestaurantServlet" class="cat-card">
      <span class="cat-emoji">🍣</span>
      <h4>Japanese</h4>
      <span>22+ places</span>
    </a>
  </div>
</section>

<!-- FEATURED RESTAURANTS -->
<section class="restaurants-section" id="restaurants">
  <div class="section-eyebrow">Top picks</div>
  <h2 class="section-title">Featured restaurants</h2>
  <p class="section-sub">Hand-picked by our team — the best in your city right now.</p>
  <div class="resto-grid">

    <a href="callRestaurantServlet" class="resto-card">
      <div class="resto-img">
        <img src="https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=600&h=340&fit=crop" alt="A2B South Indian">
        <span class="resto-badge">Popular</span>
        <span class="resto-time">25–30 min</span>
      </div>
      <div class="resto-body">
        <div class="resto-body-top">
          <span class="resto-name">A2B — Adyar Ananda Bhavan</span>
          <span class="resto-rating">4.6</span>
        </div>
        <div class="resto-meta">
          <span>South Indian</span>
          <span class="dot-sep">₹100 for one</span>
        </div>
      </div>
    </a>

    <a href="callRestaurantServlet" class="resto-card">
      <div class="resto-img">
        <img src="https://images.unsplash.com/photo-1604068549290-dea0e4a305ca?w=600&h=340&fit=crop" alt="Pizza Hut">
        <span class="resto-badge offer">30% off</span>
        <span class="resto-time">20–28 min</span>
      </div>
      <div class="resto-body">
        <div class="resto-body-top">
          <span class="resto-name">Pizza Hut</span>
          <span class="resto-rating">4.3</span>
        </div>
        <div class="resto-meta">
          <span>Italian · Pizza</span>
          <span class="dot-sep">₹350 for one</span>
        </div>
      </div>
    </a>

    <a href="callRestaurantServlet" class="resto-card">
      <div class="resto-img">
        <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&h=340&fit=crop" alt="Burger King">
        <span class="resto-badge">New</span>
        <span class="resto-time">18–25 min</span>
      </div>
      <div class="resto-body">
        <div class="resto-body-top">
          <span class="resto-name">Burger King</span>
          <span class="resto-rating">4.1</span>
        </div>
        <div class="resto-meta">
          <span>Fast Food · Burgers</span>
          <span class="dot-sep">₹220 for one</span>
        </div>
      </div>
    </a>

  </div>
</section>

<!-- PARALLAX BANNER -->
<section class="parallax-section">
  <div class="parallax-bg"></div>
  <div class="parallax-content">
    <h2>Hungry right now?<br>We've got you <em>covered</em></h2>
    <p>Fresh food from 500+ restaurants. Order in 60 seconds.</p>
    <div class="parallax-actions">
      <a href="callRestaurantServlet" class="btn-hero-primary">Order now</a>
      <a href="register.html" class="btn-hero-secondary">Create account →</a>
    </div>
  </div>
</section>

<!-- FEATURES / WHY US -->
<section class="features-section">
  <div class="features-grid">
    <div>
      <div class="section-eyebrow">Why Zestora?</div>
      <h2 class="section-title">Fast, fresh,<br>and reliable</h2>
      <div class="feature-list">
        <div class="feature-item">
          <div class="feature-icon">⚡</div>
          <div>
            <h4>Lightning-fast delivery</h4>
            <p>Our agents are always nearby. Average delivery time under 30 minutes, guaranteed.</p>
          </div>
        </div>
        <div class="feature-item">
          <div class="feature-icon">🛡</div>
          <div>
            <h4>100% safe & hygienic</h4>
            <p>All restaurants are verified. Tamper-proof packaging on every order.</p>
          </div>
        </div>
        <div class="feature-item">
          <div class="feature-icon">💰</div>
          <div>
            <h4>Best prices, always</h4>
            <p>No hidden charges. Menu prices are the same as dining in — no markup.</p>
          </div>
        </div>
        <div class="feature-item">
          <div class="feature-icon">🎧</div>
          <div>
            <h4>24/7 customer support</h4>
            <p>Something wrong? We resolve every issue within minutes, any time of day.</p>
          </div>
        </div>
      </div>
    </div>
    <div class="features-visual">
      <img src="https://images.unsplash.com/photo-1526367790999-0150786686a2?w=700&h=525&fit=crop" alt="Fresh food delivery">
      <div class="features-float">
        <div class="float-label">Today's deliveries</div>
        <div class="float-val">2,847 orders</div>
        <div class="float-sub">↑ 12% from yesterday</div>
      </div>
    </div>
  </div>
</section>

<!-- TESTIMONIALS -->
<section class="testimonials-section">
  <div class="center">
    <div class="section-eyebrow">Real reviews</div>
    <h2 class="section-title" style="color:#fff;">Loved by food lovers</h2>
    <p class="section-sub">Don't take our word for it — here's what our customers say.</p>
  </div>
  <div class="testimonials-grid">
    <div class="testi-card">
      <div class="testi-stars">★★★★★</div>
      <p class="testi-text">"Zestora is the only app I use now. Delivery is always on time and the food arrives hot. The variety of restaurants is insane!"</p>
      <div class="testi-author">
        <img class="testi-avatar" src="https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=80&h=80&fit=crop&face" alt="Priya">
        <div>
          <div class="testi-name">Priya Sharma</div>
          <div class="testi-loc">Koramangala, Bangalore</div>
        </div>
      </div>
    </div>
    <div class="testi-card">
      <div class="testi-stars">★★★★★</div>
      <p class="testi-text">"Ordered from A2B at 11pm and food arrived in 22 minutes. Absolutely unreal service. The ghee roast dosa was still crispy!"</p>
      <div class="testi-author">
        <img class="testi-avatar" src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=80&h=80&fit=crop&face" alt="Ravi">
        <div>
          <div class="testi-name">Ravi Kumar</div>
          <div class="testi-loc">Indiranagar, Bangalore</div>
        </div>
      </div>
    </div>
    <div class="testi-card">
      <div class="testi-stars">★★★★☆</div>
      <p class="testi-text">"The app is clean and super easy to use. I love that I can track my order. Customer support resolved my query in 3 minutes flat."</p>
      <div class="testi-author">
        <img class="testi-avatar" src="https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=80&h=80&fit=crop&face" alt="Ananya">
        <div>
          <div class="testi-name">Ananya Menon</div>
          <div class="testi-loc">Whitefield, Bangalore</div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- APP DOWNLOAD BANNER -->
<section class="app-section">
  <div class="section-eyebrow" style="color:var(--gold); justify-content:center;">Get the app</div>
  <h2 class="section-title">Order on the go</h2>
  <p class="section-sub">Download the Zestora app and get ₹100 off your first order.</p>
  <div class="app-badges">
    <a href="#" class="app-badge">
      <svg viewBox="0 0 24 24" fill="currentColor"><path d="M17.05 20.28c-.98.95-2.05.8-3.08.35-1.09-.46-2.09-.48-3.24 0-1.44.62-2.2.44-3.06-.35C2.79 15.25 3.51 7.7 9.05 7.42c1.42.07 2.41.78 3.24.8 1.23-.24 2.41-1 3.73-.84 1.58.19 2.76.84 3.54 2.07-3.28 1.92-2.73 6.14.49 7.35-.57 1.48-1.32 2.94-3 3.48zM12.03 7.25c-.15-2.23 1.66-4.07 3.74-4.25.29 2.58-2.34 4.5-3.74 4.25z"/></svg>
      <div class="app-badge-text">
        <span class="small">Download on the</span>
        <span class="big">App Store</span>
      </div>
    </a>
    <a href="#" class="app-badge">
      <svg viewBox="0 0 24 24" fill="currentColor"><path d="M3.18 23.76a2 2 0 0 0 2.89.77l9.38-5.42-2.63-2.63-9.64 7.28zM20.7 9.46l-3.5-2.02-2.96 2.96 2.96 2.96 3.53-2.04a2 2 0 0 0-.03-3.86zM2.01 1.22A2 2 0 0 0 2 1.8v20.4a2 2 0 0 0 .01.58l.09.08 11.44-11.44-.09-.09L2.1 1.14l-.09.08zm5.43 5.92L18.88 13 15.9 16l-11.44-11.44 2.98 2.58z"/></svg>
      <div class="app-badge-text">
        <span class="small">Get it on</span>
        <span class="big">Google Play</span>
      </div>
    </a>
  </div>
</section>

<!-- FOOTER -->
<footer>
  <div class="footer-grid">
    <div class="footer-brand">
      <a href="index.jsp" class="logo">Zest<span class="dot">ora</span></a>
      <p>Delivering happiness, one meal at a time. Order from the best restaurants in your city.</p>
    </div>
    <div class="footer-col">
      <h5>Company</h5>
      <ul>
        <li><a href="#">About us</a></li>
        <li><a href="#">Careers</a></li>
        <li><a href="#">Blog</a></li>
        <li><a href="#">Press</a></li>
      </ul>
    </div>
    <div class="footer-col">
      <h5>For you</h5>
      <ul>
        <li><a href="callRestaurantServlet">Restaurants</a></li>
        <li><a href="login.jsp">Login</a></li>
        <li><a href="register.html">Sign up</a></li>
        <li><a href="#">Track order</a></li>
      </ul>
    </div>
    <div class="footer-col">
      <h5>Support</h5>
      <ul>
        <li><a href="#">Help center</a></li>
        <li><a href="#">Privacy policy</a></li>
        <li><a href="#">Terms of service</a></li>
        <li><a href="#">Contact us</a></li>
      </ul>
    </div>
  </div>
  <div class="footer-bottom">
    <span>© 2026 Zestora. Built with ❤ for food lovers.</span>
    <div class="footer-socials">
      <a href="#" title="Instagram">📸</a>
      <a href="#" title="Twitter">🐦</a>
      <a href="#" title="Facebook">📘</a>
      <a href="#" title="YouTube">▶</a>
    </div>
  </div>
</footer>

</body>
</html>
/**
 * Epic Tech AI — hero WebGL (Three.js r160 CDN)
 * Neural lattice + energy core. Graceful no-WebGL fallback.
 */
(function () {
  const canvas = document.getElementById("hero-canvas");
  if (!canvas || typeof THREE === "undefined") return;

  const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  let renderer, scene, camera, core, lattice, stars, mouse = { x: 0, y: 0 }, raf = 0;
  let w = 0, h = 0, dpr = 1;

  function init() {
    try {
      renderer = new THREE.WebGLRenderer({
        canvas,
        antialias: true,
        alpha: true,
        powerPreference: "high-performance",
      });
    } catch (e) {
      canvas.style.display = "none";
      return;
    }

    dpr = Math.min(window.devicePixelRatio || 1, 2);
    scene = new THREE.Scene();
    camera = new THREE.PerspectiveCamera(42, 1, 0.1, 100);
    camera.position.set(0, 0.15, 5.2);

    // Soft fog for depth
    scene.fog = new THREE.FogExp2(0x05050a, 0.06);

    // --- Starfield ---
    {
      const n = reduceMotion ? 400 : 1200;
      const pos = new Float32Array(n * 3);
      for (let i = 0; i < n; i++) {
        const r = 8 + Math.random() * 18;
        const t = Math.random() * Math.PI * 2;
        const p = Math.acos(2 * Math.random() - 1);
        pos[i * 3] = r * Math.sin(p) * Math.cos(t);
        pos[i * 3 + 1] = r * Math.sin(p) * Math.sin(t);
        pos[i * 3 + 2] = r * Math.cos(p);
      }
      const g = new THREE.BufferGeometry();
      g.setAttribute("position", new THREE.BufferAttribute(pos, 3));
      stars = new THREE.Points(
        g,
        new THREE.PointsMaterial({
          color: 0xa78bfa,
          size: 0.02,
          transparent: true,
          opacity: 0.55,
          depthWrite: false,
          blending: THREE.AdditiveBlending,
        })
      );
      scene.add(stars);
    }

    // --- Neural lattice (fibonacci sphere + links) ---
    {
      const N = reduceMotion ? 48 : 96;
      const pts = [];
      const golden = Math.PI * (3 - Math.sqrt(5));
      for (let i = 0; i < N; i++) {
        const y = 1 - (i / (N - 1)) * 2;
        const radius = Math.sqrt(1 - y * y);
        const theta = golden * i;
        pts.push(new THREE.Vector3(Math.cos(theta) * radius, y, Math.sin(theta) * radius).multiplyScalar(1.65));
      }

      const positions = new Float32Array(N * 3);
      pts.forEach((p, i) => {
        positions[i * 3] = p.x;
        positions[i * 3 + 1] = p.y;
        positions[i * 3 + 2] = p.z;
      });

      const pGeo = new THREE.BufferGeometry();
      pGeo.setAttribute("position", new THREE.BufferAttribute(positions, 3));
      const nodes = new THREE.Points(
        pGeo,
        new THREE.PointsMaterial({
          color: 0x22d3ee,
          size: 0.045,
          transparent: true,
          opacity: 0.95,
          depthWrite: false,
          blending: THREE.AdditiveBlending,
        })
      );

      // Connect near neighbors
      const linePos = [];
      const maxDist = 1.15;
      for (let i = 0; i < N; i++) {
        for (let j = i + 1; j < N; j++) {
          if (pts[i].distanceTo(pts[j]) < maxDist) {
            linePos.push(pts[i].x, pts[i].y, pts[i].z, pts[j].x, pts[j].y, pts[j].z);
          }
        }
      }
      const lGeo = new THREE.BufferGeometry();
      lGeo.setAttribute("position", new THREE.Float32BufferAttribute(linePos, 3));
      const lines = new THREE.LineSegments(
        lGeo,
        new THREE.LineBasicMaterial({
          color: 0x8b5cf6,
          transparent: true,
          opacity: 0.28,
          blending: THREE.AdditiveBlending,
          depthWrite: false,
        })
      );

      lattice = new THREE.Group();
      lattice.add(lines);
      lattice.add(nodes);
      scene.add(lattice);
    }

    // --- Energy core ---
    {
      const geo = new THREE.IcosahedronGeometry(0.55, 2);
      const mat = new THREE.MeshBasicMaterial({
        color: 0xc4b5fd,
        wireframe: true,
        transparent: true,
        opacity: 0.55,
      });
      core = new THREE.Mesh(geo, mat);

      const glow = new THREE.Mesh(
        new THREE.SphereGeometry(0.42, 32, 32),
        new THREE.MeshBasicMaterial({
          color: 0x22d3ee,
          transparent: true,
          opacity: 0.12,
          blending: THREE.AdditiveBlending,
          depthWrite: false,
        })
      );
      const ring = new THREE.Mesh(
        new THREE.TorusGeometry(0.95, 0.008, 16, 100),
        new THREE.MeshBasicMaterial({
          color: 0x34d399,
          transparent: true,
          opacity: 0.5,
          blending: THREE.AdditiveBlending,
        })
      );
      ring.rotation.x = Math.PI / 2.4;

      const ring2 = ring.clone();
      ring2.rotation.x = Math.PI / 1.7;
      ring2.rotation.y = 0.6;
      ring2.material = ring.material.clone();
      ring2.material.color = new THREE.Color(0xa78bfa);
      ring2.scale.setScalar(1.15);

      core.add(glow);
      core.add(ring);
      core.add(ring2);
      scene.add(core);
    }

    // Lights (subtle — mostly additive materials)
    scene.add(new THREE.AmbientLight(0xffffff, 0.4));

    onResize();
    window.addEventListener("resize", onResize, { passive: true });
    window.addEventListener(
      "pointermove",
      (e) => {
        mouse.x = (e.clientX / window.innerWidth) * 2 - 1;
        mouse.y = -(e.clientY / window.innerHeight) * 2 + 1;
      },
      { passive: true }
    );

    if (!reduceMotion) animate(0);
    else {
      renderer.render(scene, camera);
    }
  }

  function onResize() {
    const parent = canvas.parentElement || document.body;
    w = parent.clientWidth || window.innerWidth;
    h = parent.clientHeight || window.innerHeight;
    camera.aspect = w / h;
    camera.updateProjectionMatrix();
    renderer.setPixelRatio(dpr);
    renderer.setSize(w, h, false);
  }

  function animate(t) {
    raf = requestAnimationFrame(animate);
    const time = t * 0.001;

    if (core) {
      core.rotation.y = time * 0.25;
      core.rotation.x = Math.sin(time * 0.3) * 0.12;
      core.position.y = Math.sin(time * 0.8) * 0.06;
    }
    if (lattice) {
      lattice.rotation.y = time * 0.08 + mouse.x * 0.15;
      lattice.rotation.x = mouse.y * 0.1;
    }
    if (stars) {
      stars.rotation.y = time * 0.02;
    }

    camera.position.x += (mouse.x * 0.35 - camera.position.x) * 0.04;
    camera.position.y += (mouse.y * 0.2 + 0.15 - camera.position.y) * 0.04;
    camera.lookAt(0, 0, 0);

    renderer.render(scene, camera);
  }

  // Boot after fonts/layout
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();

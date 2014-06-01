class Flock {
  ArrayList<Particle> particles; // An ArrayList for all the boids

  Flock() {
    particles = new ArrayList<Particle>(); // Initialize the ArrayList
  }
  
  ArrayList<Particle> getFlock()
  {
    return particles;
  }

  void run() {
    for (Particle b : particles) {
      b.run(particles);  // Passing the entire list of boids to each boid individually
    }
  }

  void addParticle(Particle b) {
    particles.add(b);
     
  }

}

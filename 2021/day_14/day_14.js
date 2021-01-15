// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Vertex class contains three coordinates
 */
class Vertex {
  constructor(x, y, z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  /**
   * Compute the average location of a list of vertices
   */
  static average(vertices) {
    let xSum = 0, ySum = 0, zSum = 0;

    for (let i = 0; i < vertices.length; i++) {
      const vert = vertices[i];

      xSum += vert.x;
      ySum += vert.y;
      zSum += vert.z;
    }

    xSum /= vertices.length;
    ySum /= vertices.length;
    zSum /= vertices.length;

    return new Vertex(xSum, ySum, zSum);
  }

  /**
   * Add two vertices together (vector add)
   */
  static add(v1, v2) {
    return new Vertex(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
  }

  /**
   * Multiply a vertex by a certain amount
   */
  static mult(v, n) {
    return new Vertex(v.x * n, v.y * n, v.z * n);
  }

  /**
   * Divide a vertex by a certain amount
   */
  static div(v, n) {
    return new Vertex(v.x / n, v.y / n, v.z / n);
  }

  /**
   * Setter for three components
   */
  set(v) {
    this.x = v.x;
    this.y = v.y;
    this.z = v.z;
  }

  display() {
    point(this.x, this.y, this.z);
  }
}

/**
 * Edge class contains two vertex indices
 */
class Edge {
  constructor(v1, v2) {
    this.vertexIndices = [v1, v2];
  }

  isConnectedTo(e) {
    return this.vertexIndices[0] == e.vertexIndices[0] || 
      this.vertexIndices[1] == e.vertexIndices[1] || 
      this.vertexIndices[1] == e.vertexIndices[0] ||
      this.vertexIndices[0] == e.vertexIndices[1];
  }
}

/**
 * Face class contains a list of edge indices
 */
class Face {
  constructor(e1, e2, e3, e4) {
    this.edgeIndices = [e1, e2, e3, e4];
  }
}

/**
 * Mesh class contains a list of faces that references a list of edges
 * that themselves reference a list of vertices
 */
class Mesh {
  constructor(vertices, edges, faces) {
    this.vertices = vertices;
    this.edges = edges;
    this.faces = faces;
  }

  /**
   * Return the list of vertex indices for a face
   */
  getFaceVertexIndices(faceIndex) {
    const vertexIndices = new Set();

    const face = this.faces[faceIndex];
    for (let i = 0; i < face.edgeIndices.length; i++) {
      const edge = this.edges[face.edgeIndices[i]];
      for (let j = 0; j < edge.vertexIndices.length; j++) {
        vertexIndices.add(edge.vertexIndices[j]);
      }
    }

    return Array.from(vertexIndices);
  }

  /**
   * Return the average point of a face
   */
  getFacePoint(faceIndex) {
    const vertexIndices = this.getFaceVertexIndices(faceIndex);
    const vertices = vertexIndices.map(i => this.vertices[i]);

    return Vertex.average(vertices);
  }

  /**
   * Return the indices of the neighbour faces of an edge
   */
  getEdgeNeighbourFaceIndices(edgeIndex) {
    const faceIndices = [];

    for (let i = 0; i < this.faces.length; i++) {
      if (this.faces[i].edgeIndices.includes(edgeIndex)) {
        faceIndices.push(i);
      }
    }

    return faceIndices;
  }

  /**
   * Return the indices of the neighbour edges of a vertex
   */
  getVertexNeighbourEdgeIndices(vertexIndex) {
    const edgeIndices = [];

    for (let i = 0; i < this.edges.length; i++) {
      if (this.edges[i].vertexIndices.includes(vertexIndex)) {
        edgeIndices.push(i);
      }
    }

    return edgeIndices;
  }

  /**
   * Return the indices of the neighbour faces of a vertex
   */
  getVertexNeighbourFaceIndices(vertexIndex) {
    let faceIndices = new Set();

    this.getVertexNeighbourEdgeIndices(vertexIndex).forEach(ei => {
      this.getEdgeNeighbourFaceIndices(ei).forEach(fi => {
        faceIndices.add(fi)
      })
    });

    return Array.from(faceIndices);
  }

  /**
   * Catmull-Clark algorithm
   * See : https://en.wikipedia.org/wiki/Catmull–Clark_subdivision_surface 
   */
  subdivide(level) {
    if (level == 0) return;

    // Compute face points
    const facePoints = this.faces.map((f, i) => this.getFacePoint(i));

    // Compute edge points by averaging with face points
    const edgePoints = [];
    for (let i = 0; i < this.edges.length; i++) {
      const ngbhFaceIndices = this.getEdgeNeighbourFaceIndices(i);
      const nghbFacePoints = ngbhFaceIndices.map(i => facePoints[i]);
      const edgeVertices = this.edges[i].vertexIndices.map(i => this.vertices[i]);
      edgePoints.push(Vertex.average(edgeVertices.concat(nghbFacePoints)));
    }

    // Move P to the barycenter
    for (let i = 0; i < this.vertices.length; i++) {
      const F = Vertex.average(this.getVertexNeighbourFaceIndices(i).map(i => facePoints[i]));

      const P = this.vertices[i];
      const edgesTouchingP = this.getVertexNeighbourEdgeIndices(i);
      const n = edgesTouchingP.length + 1;
      const R = Vertex.average(edgesTouchingP.map(i => edgePoints[i]));
      const newPosition = Vertex.div(Vertex.add(F, Vertex.add(Vertex.mult(R, 2), Vertex.mult(P, n - 3))), n);

      P.set(newPosition);
    }

    const newEdges = [];

    // Stores adjacent edge points of face points
    const adjacentEdgePointsOfFacePoints = [];

    // Connect each new face point to the new edge points of all original edges defining the original face.
    for (let i = 0; i < facePoints.length; i++) {
      const face = this.faces[i];
      const facePoint = facePoints[i];

      const adjacentEdges = [];
      for (const faceEdgeIndex of face.edgeIndices) {
        const fpIndex = this.vertices.length + i;
        const epIndex = this.vertices.length + facePoints.length + faceEdgeIndex;

        adjacentEdges.push(newEdges.length);
        newEdges.push(new Edge(fpIndex, epIndex));
      }

      adjacentEdgePointsOfFacePoints.push({
        facePoint: this.vertices.length + i, 
        connected: adjacentEdges
      });
    }

    // Stores the adjacent edge points of each original vertex
    const adjacentEdgePointsOfP = [];

    // Connect each new vertex point to the new edge points of all original edges incident on the original vertex.
    for (let i = 0; i < this.vertices.length; i++) {
      const edgeIndices = this.getVertexNeighbourEdgeIndices(i);

      const adjacentEdges = [];

      for (const edgeIndex of edgeIndices) {
        const epIndex = this.vertices.length + facePoints.length + edgeIndex;

        adjacentEdges.push(newEdges.length);
        newEdges.push(new Edge(i, epIndex));
      }

      adjacentEdgePointsOfP.push({
        originalVertex: i,
        connected: adjacentEdges
      });
    }

    // Apply new edges
    this.edges = newEdges;

    const newFaces = [];

    // Define new faces as enclosed by edges.
    for (const fp of adjacentEdgePointsOfFacePoints) {
      for (const P of adjacentEdgePointsOfP) {
        const sharedEdges = [];

        for (const fpAdj of fp.connected) {
          for (const PAdj of P.connected) {
            if (this.edges[fpAdj].isConnectedTo(this.edges[PAdj])) {
              sharedEdges.push(fpAdj);
              sharedEdges.push(PAdj);
            }
          }
        }

        // It's a new face if there's 4 edges
        if (sharedEdges.length == 4) {
          newFaces.push(new Face(sharedEdges[0], sharedEdges[1], sharedEdges[2], sharedEdges[3]));
        }
      }
    }

    // Apply new faces
    this.faces = newFaces;

    // Add new points
    this.vertices = this.vertices.concat(facePoints).concat(edgePoints);

    // Recursive call
    this.subdivide(level - 1);
  }

  /**
   * Display mesh with scale factor
   */
  display(x, y, scaleFactor) {
    push();
    translate(x, y);
    scale(scaleFactor);

    // Display edges
    strokeWeight(1);
    stroke(255);

    for (const face of this.faces) {
      for (const edgeIndex of face.edgeIndices) {
        const edge = this.edges[edgeIndex];

        const a = this.vertices[edge.vertexIndices[0]];
        const b = this.vertices[edge.vertexIndices[1]];

        line(a.x, a.y, a.z, b.x, b.y, b.z);
      }
    }

    // Display vertices
    stroke("#ff9900");
    strokeWeight(5);

    for (let vert of this.vertices) {
      vert.display();
    }

    pop();
  }
}

function cubeVertices() {
  // Vertices
  const A = new Vertex(-1, 1, -1);
  const B = new Vertex(1, 1, -1);
  const C = new Vertex(1, -1, -1);
  const D = new Vertex(-1, -1, -1);
  
  const E = new Vertex(-1, 1, 1);
  const F = new Vertex(1, 1, 1);
  const G = new Vertex(1, -1, 1);
  const H = new Vertex(-1, -1, 1);

  const vertices = [A, B, C, D, E, F, G, H];
  
  // Edges
  const AB = new Edge(0, 1);
  const BC = new Edge(1, 2);
  const CD = new Edge(2, 3);
  const DA = new Edge(3, 0);

  const EF = new Edge(4, 5);
  const FG = new Edge(5, 6);
  const GH = new Edge(6, 7);
  const HE = new Edge(7, 4);

  const AE = new Edge(0, 4);
  const BF = new Edge(1, 5);
  const CG = new Edge(2, 6);
  const DH = new Edge(3, 7);

  const edges = [AB, BC, CD, DA, EF, FG, GH, HE, AE, BF, CG, DH];

  // Faces
  const ABCD = new Face(0, 1, 2, 3);
  const EFGH = new Face(4, 5, 6, 7);
  const DCGH = new Face(2, 10, 6, 11);
  const ADHE = new Face(3, 11, 7, 8);
  const BFGC = new Face(9, 5, 10, 1);
  const ABFE = new Face(0, 9, 4, 8);

  const faces = [ABCD, EFGH, DCGH, ADHE, BFGC, ABFE];

  return new Mesh(vertices, edges, faces);
}

let offset = 0;
let meshes = [];

function setup() {
  createCanvas(500, 500, WEBGL);
  
  setAttributes('antialias', true);
  
  for (let i = 0; i < 4; i++) {
    meshes[i] = cubeVertices();
    meshes[i].subdivide(i);
  }
}

function draw() {
  background("#003344");
  
  rotateY(offset);
  rotateX(offset / 2);

  meshes[int((offset) % meshes.length)].display(0, 0, 150);
  
  offset += 0.01;
  // noLoop();
}


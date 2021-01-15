// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

import java.util.*;

/**
 * Vertex class contains three coordinates
 */
class Vertex {
  float x, y, z;

  Vertex(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  /**
   * Add two vertices together (vector add)
   */
  Vertex add(Vertex v) {
    return new Vertex(x + v.x, y + v.y, z + v.z);
  }

  /**
   * Multiply a vertex by a certain amount
   */
  Vertex mult(float n) {
    return new Vertex(x * n, y * n, z * n);
  }

  /**
   * Divide a vertex by a certain amount
   */
  Vertex div(float n) {
    return new Vertex(x / n, y / n, z / n);
  }

  /**
   * Setter for three components
   */
  void set(Vertex v) {
    this.x = v.x;
    this.y = v.y;
    this.z = v.z;
  }

  void display(float scaleFactor) {
    point(this.x * scaleFactor, this.y * scaleFactor, this.z * scaleFactor);
  }

  String toString() {
    return "[" + x + ", " + y + ", " + z + "]";
  }
}

/**
 * Compute the average location of a list of vertices
 */
Vertex average(List<Vertex> vertices) {
  float xSum = 0, ySum = 0, zSum = 0;

  for (Vertex vert : vertices) {
    xSum += vert.x;
    ySum += vert.y;
    zSum += vert.z;
  }

  xSum /= (float) vertices.size();
  ySum /= (float) vertices.size();
  zSum /= (float) vertices.size();

  return new Vertex(xSum, ySum, zSum);
}

/**
 * Edge class contains two vertex indices
 */
class Edge {
  int vertexIndices[] = new int[2];

  Edge(int v1, int v2) {
    this.vertexIndices[0] = v1;
    this.vertexIndices[1] = v2;
  }

  boolean isConnectedTo(Edge e) {
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
  int edgeIndices[] = new int[4];

  Face(int e1, int e2, int e3, int e4) {
    this.edgeIndices[0] = e1;
    this.edgeIndices[1] = e2;
    this.edgeIndices[2] = e3;
    this.edgeIndices[3] = e4;
  }
}

class VertexNeighbour {
  int vertexIndex;
  List<Integer> neighbours;

  VertexNeighbour(int index, List<Integer> neighbours) {
    this.vertexIndex = index;
    this.neighbours = neighbours;
  }
}

/**
 * Mesh class contains a list of faces that references a list of edges
 * that themselves reference a list of vertices
 */
class Mesh {
  List<Vertex> vertices;
  List<Edge> edges;
  List<Face> faces;

  Mesh(List<Vertex> vertices, List<Edge> edges, List<Face> faces) {
    this.vertices = vertices;
    this.edges = edges;
    this.faces = faces;
  }

  /**
   * Return the list of vertex indices for a face
   */
  List<Integer> getFaceVertexIndices(int faceIndex) {
    Set<Integer> vertexIndices = new HashSet<Integer>();

    Face face = this.faces.get(faceIndex);
    for (int i = 0; i < face.edgeIndices.length; i++) {
      Edge edge = this.edges.get(face.edgeIndices[i]);
      for (int j = 0; j < edge.vertexIndices.length; j++) {
        vertexIndices.add(edge.vertexIndices[j]);
      }
    }

    return new ArrayList<Integer>(vertexIndices);
  }

  /**
   * Return the average point of a face
   */
  Vertex getFacePoint(int faceIndex) {
    List<Integer> vertexIndices = this.getFaceVertexIndices(faceIndex);

    List<Vertex> vertices = new ArrayList<Vertex>();
    for (int i = 0; i < vertexIndices.size(); i++) {
      vertices.add(this.vertices.get(vertexIndices.get(i)));
    }

    return average(vertices);
  }

  /**
   * Return the indices of the neighbour faces of an edge
   */
  List<Integer> getEdgeNeighbourFaceIndices(int edgeIndex) {
    List<Integer> faceIndices = new ArrayList<Integer>();

    for (int i = 0; i < this.faces.size(); i++) {
      /*if (Arrays.asList(this.faces.get(i).edgeIndices).contains(edgeIndex)) {
       faceIndices.add(i);
       }*/

      int edgeIndices[] = this.faces.get(i).edgeIndices;
      for (int j = 0; j < edgeIndices.length; j++) {
        if (edgeIndices[j] == edgeIndex) {
          faceIndices.add(i);
          break;
        }
      }
    }

    return faceIndices;
  }

  /**
   * Return the indices of the neighbour edges of a vertex
   */
  List<Integer> getVertexNeighbourEdgeIndices(int vertexIndex) {
    List<Integer> edgeIndices = new ArrayList<Integer>();

    for (int i = 0; i < this.edges.size(); i++) {
      int vertexIndices[] = this.edges.get(i).vertexIndices;
      for (int j = 0; j < vertexIndices.length; j++) {
        if (vertexIndices[j] == vertexIndex) {
          edgeIndices.add(i);
          break;
        }
      }
    }

    return edgeIndices;
  }

  /**
   * Return the indices of the neighbour faces of a vertex
   */
  List<Integer> getVertexNeighbourFaceIndices(int vertexIndex) {
    Set<Integer> faceIndices = new HashSet<Integer>();

    List<Integer> edgeIndices = this.getVertexNeighbourEdgeIndices(vertexIndex);

    for (Integer ei : edgeIndices) {
      List<Integer> nFaceIndices = this.getEdgeNeighbourFaceIndices(ei);
      for (Integer fi : nFaceIndices) {
        faceIndices.add(fi);
      }
    }

    return new ArrayList<Integer>(faceIndices);
  }

  /**
   * Catmull-Clark algorithm
   * See : https://en.wikipedia.org/wiki/Catmull–Clark_subdivision_surface 
   */
  void subdivide(int level) {
    if (level == 0) return;

    // Compute face points
    List<Vertex> facePoints = new ArrayList<Vertex>();

    for (int i = 0; i < this.faces.size(); i++) {
      facePoints.add(this.getFacePoint(i));
    }

    // Compute edge points by averaging with face points
    List<Vertex> edgePoints = new ArrayList<Vertex>();
    for (int i = 0; i < this.edges.size(); i++) {
      List<Integer> ngbhFaceIndices = this.getEdgeNeighbourFaceIndices(i);

      List<Vertex> nghbFacePoints = new ArrayList<Vertex>();
      for (Integer fi : ngbhFaceIndices) {
        nghbFacePoints.add(facePoints.get(fi));
      }

      List<Vertex> edgeVertices = new ArrayList<Vertex>();
      for (int j = 0; j < this.edges.get(i).vertexIndices.length; j++) {
        int ei = this.edges.get(i).vertexIndices[j];
        edgeVertices.add(this.vertices.get(ei));
        edgeVertices.get(j).display(100);
      }

      List<Vertex> avg = new ArrayList<Vertex>(edgeVertices);
      avg.addAll(nghbFacePoints);
      edgePoints.add(average(avg));
    }

    // Move P to the barycenter
    for (int i = 0; i < this.vertices.size(); i++) {
      List<Integer> nghbFacePointsIndices = this.getVertexNeighbourFaceIndices(i);

      List<Vertex> nghbFacePoints = new ArrayList<Vertex>();
      for (int j = 0; j < nghbFacePointsIndices.size(); j++) {
        nghbFacePoints.add(facePoints.get(nghbFacePointsIndices.get(j)));
      }

      Vertex F = average(nghbFacePoints);

      Vertex P = this.vertices.get(i);
      List<Integer> edgesTouchingP = this.getVertexNeighbourEdgeIndices(i);
      int n = edgesTouchingP.size() + 1;

      List<Vertex> edgesNextToP = new ArrayList<Vertex>();
      for (Integer ei : edgesTouchingP) {
        edgesNextToP.add(edgePoints.get(ei));
      }
      Vertex R = average(edgesNextToP);

      // Vertex newPosition = div(add(F, add(mult(R, 2), mult(P, n - 3))), n);
      Vertex newPosition = F.add(R.mult(2).add(P.mult(n - 3))).div(n);
      //Vertex newPosition = new Vertex((F.x + 2 * R.x + (n - 3) * P.x)/n, (F.y + 2 * R.y + (n - 3) * P.y)/n, (F.z + 2 * R.z + (n - 3) * P.z)/n);

      P.set(newPosition);
    }

    List<Edge> newEdges = new ArrayList<Edge>();

    // Stores adjacent edge points of face points
    List<VertexNeighbour> adjacentEdgePointsOfFacePoints = new ArrayList<VertexNeighbour>();

    // Connect each new face point to the new edge points of all original edges defining the original face.
    for (int i = 0; i < facePoints.size(); i++) {
      Face face = this.faces.get(i);
      // Vertex facePoint = facePoints.get(i);

      List<Integer> adjacentEdges = new ArrayList<Integer>();
      for (int j = 0; j < face.edgeIndices.length; j++) {
        int fpIndex = this.vertices.size() + i;
        int epIndex = this.vertices.size() + facePoints.size() + face.edgeIndices[j];

        adjacentEdges.add(newEdges.size());
        newEdges.add(new Edge(fpIndex, epIndex));
      }

      adjacentEdgePointsOfFacePoints.add(new VertexNeighbour(this.vertices.size() + i, adjacentEdges));
    }

    // Stores the adjacent edge points of each original vertex
    List<VertexNeighbour> adjacentEdgePointsOfP = new ArrayList<VertexNeighbour>();

    // Connect each new vertex point to the new edge points of all original edges incident on the original vertex.
    for (int i = 0; i < this.vertices.size(); i++) {
      List<Integer> edgeIndices = this.getVertexNeighbourEdgeIndices(i);

      List<Integer> adjacentEdges = new ArrayList<Integer>();

      for (int j = 0; j < edgeIndices.size(); j++) {
        int epIndex = this.vertices.size() + facePoints.size() + edgeIndices.get(j);

        adjacentEdges.add(newEdges.size());
        newEdges.add(new Edge(i, epIndex));
      }

      adjacentEdgePointsOfP.add(new VertexNeighbour(i, adjacentEdges));
    }

    // Apply new edges
    this.edges = newEdges;

    List<Face> newFaces = new ArrayList<Face>();

    // Define new faces as enclosed by edges.
    for (VertexNeighbour fp : adjacentEdgePointsOfFacePoints) {
      for (VertexNeighbour P : adjacentEdgePointsOfP) {
        List<Integer> sharedEdges = new ArrayList<Integer>();

        for (Integer fpAdj : fp.neighbours) {
          for (Integer PAdj : P.neighbours) {
            if (this.edges.get(fpAdj).isConnectedTo(this.edges.get(PAdj))) {
              sharedEdges.add(fpAdj);
              sharedEdges.add(PAdj);
            }
          }
        }

        // It's a new face if there's 4 edges
        if (sharedEdges.size() == 4) {
          newFaces.add(new Face(sharedEdges.get(0), sharedEdges.get(1), sharedEdges.get(2), sharedEdges.get(3)));
        }
      }
    }

    // Apply new faces
    this.faces = newFaces;

    // Add new points
    this.vertices.addAll(facePoints);
    this.vertices.addAll(edgePoints);

    // Recursive call
    this.subdivide(level - 1);
  }

  /**
   * Display mesh with scale factor
   */
  void display(float x, float y, float scaleFactor, float pointStrokeSize, float lineStrokeSize, float offset) {
    pushMatrix();
    translate(x, y);

    // Display edges
    
    float amount = ((cos(offset * 2) + 1) / 2);

    for (int i = 0; i < faces.size() * amount; i++) {
      Face face = faces.get(i);
      for (int j = 0; j < face.edgeIndices.length * amount; j++) {
        Edge edge = this.edges.get(face.edgeIndices[j]);

        Vertex a = this.vertices.get(edge.vertexIndices[0]);
        Vertex b = this.vertices.get(edge.vertexIndices[1]);
        
        stroke(255, 153, 0, 200);
        strokeWeight(pointStrokeSize);
        a.display(scaleFactor);
        b.display(scaleFactor);
        
        strokeWeight(lineStrokeSize);
        stroke(255, 60);
        line(a.x * scaleFactor, a.y * scaleFactor, a.z * scaleFactor, b.x * scaleFactor, b.y * scaleFactor, b.z * scaleFactor);
      }
    }

    // Display vertices
    strokeWeight(3);
    for (Vertex vert : this.vertices) {
      vert.display(scaleFactor);
    }

    popMatrix();
  }
}

Mesh cubeVertices() {
  // Vertices
  Vertex A = new Vertex(-1, 1, -1);
  Vertex B = new Vertex(1, 1, -1);
  Vertex C = new Vertex(1, -1, -1);
  Vertex D = new Vertex(-1, -1, -1);

  Vertex E = new Vertex(-1, 1, 1);
  Vertex F = new Vertex(1, 1, 1);
  Vertex G = new Vertex(1, -1, 1);
  Vertex H = new Vertex(-1, -1, 1);

  List<Vertex> vertices = new ArrayList<Vertex>();
  vertices.addAll(Arrays.asList(A, B, C, D, E, F, G, H));

  // Edges
  Edge AB = new Edge(0, 1);
  Edge BC = new Edge(1, 2);
  Edge CD = new Edge(2, 3);
  Edge DA = new Edge(3, 0);

  Edge EF = new Edge(4, 5);
  Edge FG = new Edge(5, 6);
  Edge GH = new Edge(6, 7);
  Edge HE = new Edge(7, 4);

  Edge AE = new Edge(0, 4);
  Edge BF = new Edge(1, 5);
  Edge CG = new Edge(2, 6);
  Edge DH = new Edge(3, 7);

  List<Edge> edges = new ArrayList<Edge>();
  edges.addAll(Arrays.asList(AB, BC, CD, DA, EF, FG, GH, HE, AE, BF, CG, DH));

  // Faces
  Face ABCD = new Face(0, 1, 2, 3);
  Face EFGH = new Face(4, 5, 6, 7);
  Face DCGH = new Face(2, 10, 6, 11);
  Face ADHE = new Face(3, 11, 7, 8);
  Face BFGC = new Face(9, 5, 10, 1);
  Face ABFE = new Face(0, 9, 4, 8);

  List<Face> faces = new ArrayList<Face>();
  faces.addAll(Arrays.asList(ABCD, EFGH, DCGH, ADHE, BFGC, ABFE));

  return new Mesh(vertices, edges, faces);
}

float offset = 0;
List<Mesh> meshes = new ArrayList<Mesh>();

void settings() {
  System.setProperty("jogl.disable.openglcore", "true");
  size(500, 500, P3D);
}

void setup() {
  for (int i = 0; i < 5; i++) {
    meshes.add(cubeVertices());
    meshes.get(i).subdivide(i);
  }
}

void draw() {
  background(#003344);

  int index = round(((cos(PI + offset / 2) + 1) / 2) * (meshes.size() - 1));
  float pointStroke = map(index, 0, meshes.size() - 1, 8, 3);
  float lineStroke = map(index, 0, meshes.size() - 1, 3, 1);
  
  for (int i = 0; i < 1; i++) {
    float off = i * 0.1;
    
    pushMatrix();
    translate(width / 2, height / 2);
    
    rotateY(offset + off);
    rotateX(offset / 2 );
    
    meshes.get(index).display(0, 0, 110, pointStroke, lineStroke, offset);
    
    popMatrix();
  }

  offset += 0.01;
}


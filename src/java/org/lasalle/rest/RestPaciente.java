package org.lasalle.rest;

import com.google.gson.Gson;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.sql.SQLException;
import java.util.List;
import org.lasalle.controller.ControllerPaciente;
import org.lasalle.model.Paciente;

@Path("pacientes")
public class RestPaciente {

    @GET
    @Path("getAll")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getAll() throws SQLException {
        ControllerPaciente cp = new ControllerPaciente();
        Gson gson = new Gson();
        return Response.ok(gson.toJson(cp.getAll())).build();
    }

    @GET
    @Path("getByUsuario/{idUsuario}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getByUsuario(@PathParam("idUsuario") int idUsuario) throws SQLException {
        ControllerPaciente cp = new ControllerPaciente();
        Gson gson = new Gson();
        List<Paciente> lista = cp.getByUsuario(idUsuario);
        return Response.ok(gson.toJson(lista)).build();
    }

    @GET
    @Path("getById/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getById(@PathParam("id") int id) throws SQLException {
        ControllerPaciente cp = new ControllerPaciente();
        Gson gson = new Gson();
        Paciente p = cp.getById(id);
        if (p != null) {
            return Response.ok(gson.toJson(p)).build();
        }
        return Response.status(Response.Status.NOT_FOUND)
                .entity("{\"error\":\"Paciente no encontrado\"}")
                .build();
    }

    @GET
    @Path("buscar/{nombre}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response buscar(@PathParam("nombre") String nombre) throws SQLException {
        ControllerPaciente cp = new ControllerPaciente();
        Gson gson = new Gson();
        return Response.ok(gson.toJson(cp.buscar(nombre))).build();
    }

    @POST
    @Path("insert")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Response insert(Paciente p) throws SQLException {
        ControllerPaciente cp = new ControllerPaciente();
        Gson gson = new Gson();
        p = cp.insert(p);
        return Response.ok(gson.toJson(p)).build();
    }

    @PUT
    @Path("update")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Response update(Paciente p) throws SQLException {
        ControllerPaciente cp = new ControllerPaciente();
        Gson gson = new Gson();
        p = cp.update(p);
        return Response.ok(gson.toJson(p)).build();
    }

    @DELETE
    @Path("delete/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response delete(@PathParam("id") int id) throws SQLException {
        ControllerPaciente cp = new ControllerPaciente();
        boolean ok = cp.delete(id);
        if (ok) {
            return Response.ok("{\"response\":\"Paciente eliminado\"}").build();
        }
        return Response.status(Response.Status.NOT_FOUND)
                .entity("{\"error\":\"Paciente no encontrado\"}")
                .build();
    }
}
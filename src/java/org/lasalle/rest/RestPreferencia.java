package org.lasalle.rest;

import com.google.gson.Gson;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.sql.SQLException;
import org.lasalle.controller.ControllerPreferencia;
import org.lasalle.model.Preferencia;

@Path("preferencias")
public class RestPreferencia {

    @GET
    @Path("getByPaciente/{idPaciente}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getByPaciente(@PathParam("idPaciente") int idPaciente) throws SQLException {
        ControllerPreferencia cp = new ControllerPreferencia();
        Gson gson = new Gson();
        Preferencia p = cp.getByPaciente(idPaciente);
        if (p != null) return Response.ok(gson.toJson(p)).build();
        return Response.status(Response.Status.NOT_FOUND)
                .entity("{\"error\":\"Preferencias no encontradas\"}").build();
    }

    @POST
    @Path("insert")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Response insert(Preferencia p) throws SQLException {
        ControllerPreferencia cp = new ControllerPreferencia();
        Gson gson = new Gson();
        p = cp.insert(p);
        return Response.ok(gson.toJson(p)).build();
    }

    @PUT
    @Path("update")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Response update(Preferencia p) throws SQLException {
        ControllerPreferencia cp = new ControllerPreferencia();
        Gson gson = new Gson();
        p = cp.update(p);
        return Response.ok(gson.toJson(p)).build();
    }

    @DELETE
    @Path("delete/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response delete(@PathParam("id") int id) throws SQLException {
        ControllerPreferencia cp = new ControllerPreferencia();
        boolean ok = cp.delete(id);
        if (ok) return Response.ok("{\"response\":\"Preferencias eliminadas\"}").build();
        return Response.status(Response.Status.NOT_FOUND)
                .entity("{\"error\":\"No encontrado\"}").build();
    }
}
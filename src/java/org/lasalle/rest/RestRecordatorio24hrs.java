package org.lasalle.rest;

import com.google.gson.Gson;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.sql.SQLException;
import org.lasalle.controller.ControllerRecordatorio24hrs;
import org.lasalle.model.Recordatorio24hrs;

@Path("recordatorios")
public class RestRecordatorio24hrs {

    @GET
    @Path("getByPaciente/{idPaciente}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getByPaciente(@PathParam("idPaciente") int idPaciente) throws SQLException {
        ControllerRecordatorio24hrs cr = new ControllerRecordatorio24hrs();
        Gson gson = new Gson();
        return Response.ok(gson.toJson(cr.getByPaciente(idPaciente))).build();
    }

    @POST
    @Path("insert")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Response insert(Recordatorio24hrs r) throws SQLException {
        ControllerRecordatorio24hrs cr = new ControllerRecordatorio24hrs();
        Gson gson = new Gson();
        r = cr.insert(r);
        return Response.ok(gson.toJson(r)).build();
    }

    @PUT
    @Path("update")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Response update(Recordatorio24hrs r) throws SQLException {
        ControllerRecordatorio24hrs cr = new ControllerRecordatorio24hrs();
        Gson gson = new Gson();
        r = cr.update(r);
        return Response.ok(gson.toJson(r)).build();
    }

    @DELETE
    @Path("delete/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response delete(@PathParam("id") int id) throws SQLException {
        ControllerRecordatorio24hrs cr = new ControllerRecordatorio24hrs();
        boolean ok = cr.delete(id);
        if (ok) return Response.ok("{\"response\":\"Recordatorio eliminado\"}").build();
        return Response.status(Response.Status.NOT_FOUND)
                .entity("{\"error\":\"Recordatorio no encontrado\"}").build();
    }
}